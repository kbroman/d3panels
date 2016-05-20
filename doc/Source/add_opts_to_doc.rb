#!/usr/bin/env ruby
# add chartOpts and accessors to docs

# file names
abort("Give function name.") if ARGV.length < 1
func = ARGV[0]
ifile = "#{func}.md"
ofile = "../#{func}.md"
sfile = "../../src/#{func}.coffee"
abort("No file \"#{ifile}\"") if !File.exists?(ifile)

# read chartOpts, dependencies, and accessors
#     from coffescript source file
def read_source(filename)
    ifp = File.open(filename, 'r')
    depends = nil
    chartOpts = nil
    accessors = nil
    ifp.each_line do |line|
        line.strip()
        if line =~ /^\s+\# chartOpts start/
            chartOpts = parse_chartOpts(ifp)
        elsif line =~ /^\s+\# further chartOpts:\s*(.*)/
            line = $1
            line.gsub!(/[\(\)]/, '')
            v = line.split(/\s+/)
            depends = [v[0]]
            if v.length > 1
                omit = v[2..(v.length-1)]
                depends.concat(omit) # assume one dependency; possible
            end
        elsif line =~ /^\s+\# accessors start/
            accessors = parse_accessors(ifp)

            ifp.close()

            return({:depends => depends,
                    :chartOpts => chartOpts,
                    :accessors => accessors})
        end
    end
end

# grab chartOpts lines and parse into name, default, and comment
def parse_chartOpts(ifp)
    chartOpts = []
    ifp.each_line do |line|
        line.strip()
        if line =~ /^\s+\# chartOpts end/
            return(chartOpts)
        end

        split_line = line.split(/ \# /)
        comment = (split_line[1]).strip()

        split_again = split_line[0].split(/ \? /)
        default = (split_again[1]).strip()

        name = ((split_again[0].split(/=/))[0]).strip()

        chartOpts.push({:name => name,
                        :default => default,
                        :comment => comment})
    end
end

# grab accessors and parse into name and comment
def parse_accessors(ifp)
    accessors = []
    ifp.each_line do |line|
        line.strip()
        if line =~ /^\s+\# accessors end/
            return(accessors)
        end

        split_line = line.split(/ \# /)
        comment = (split_line[1]).strip()

        name = ((split_line[0].split(/=/))[0]).strip()

        accessors.push({:name => name,
                        :comment => comment})
    end
end


# write chartOpts info
def write_chartOpts(ofp, chartOpts)

    ofp.write("### Chart options (`chartOpts`)\n\n")

    chartOpts.each do |opt|
        ofp.write("- `#{opt[:name]}` &mdash; #{opt[:comment]} \\[default `#{opt[:default]}`\\]\n")
    end
    ofp.write("\n")
end

# url for dependency
def url_depends(depends)
    "[`#{depends}`](#{depends}.md)"
end

# remove chartOpts options from depend_opts
def remove_opts(depend_opts, chartOpts)
    optnames = chartOpts.map{|z| z[:name]}

    # remove options that are also in chartOpts
    depend_opts = depend_opts.select{|z| !(optnames.include?(z[:name]))}

    return(depend_opts)
end

# write dependencies
def write_depends(ofp, depends, chartOpts)
    return() if depends.nil? or depends.length==0

    omit = []
    if depends.length > 1
        omit = depends[1..(depends.length-1)]
        omit = omit.map {|z| {:name => z}} # convert to be like chartOpts
    end
    depends = depends[0]

    depends_url = url_depends(depends)

    ofp.write("You can also use the chart options for ")
    ofp.write(depends_url + ':')
    ofp.write("\n\n")

    # write chartOpts from dependency file if not in current chartOpts
    sfile = "../../src/#{depends}.coffee"
    depends_opts = read_source(sfile)[:chartOpts]
    depends_opts = remove_opts(depends_opts, chartOpts)
    depends_opts = remove_opts(depends_opts, omit)
    for opt in depends_opts
        ofp.write("- `#{opt[:name]}` &mdash; #{opt[:comment]} \\[default `#{opt[:default]}`\\]\n")
    end

    ofp.write("\n\n")
end

# write accessor info
def write_accessors(ofp, accessors, func)

    ofp.write("### Accessors\n\n")

    accessors.each do |a|
        ofp.write("- `#{a[:name]}()` &mdash; #{a[:comment]}\n")
    end

    ofp.write("\n")

    if !(func =~ /^add_/) # add_lodcurve, add_curves, add_points behave differently
        ofp.write("Use these like this:\n\n")
        ofp.write("```coffeescript\n")
        ofp.write("mychart = d3panels.#{func}()\n")
        if func == "panelframe" # panelframe takes no data :(
            ofp.write("mychart(d3.select(\"body\"))\n")
        else
            ofp.write("mychart(d3.select(\"body\"), data)\n")
        end
        ofp.write("#{accessors[0][:name]} = mychart.#{accessors[0][:name]}()\n")
        ofp.write("```\n\n")
    end

end


# read and write doc
def add_opts_to_doc(ifile, ofile, source_info, func)
    ifp = File.open(ifile)
    ofp = File.open(ofile, 'w')

    ifp.each_line do |line|
        if line =~ /\*\*insert_chartOpts\*\*/
            write_chartOpts(ofp, source_info[:chartOpts])
            write_depends(ofp, source_info[:depends], source_info[:chartOpts])
        elsif line =~ /\*\*insert_accessors\*\*/
            write_accessors(ofp, source_info[:accessors], func)
        else
            ofp.write(line)
        end
    end

end



### now do the work
# grab chartOpts, accessors, and dependencies from source
source_info = read_source(sfile)

# paste into doc (with output file up one directory)
add_opts_to_doc(ifile, ofile, source_info, func)
