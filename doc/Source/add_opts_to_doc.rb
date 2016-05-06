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
            depends = $1.split(/\s+/)
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

        split_line = line.split(/\#/)
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

        split_line = line.split(/\#/)
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

# write dependencies
def write_depends(ofp, depends)
    return() if depends.nil? or depends.length==0

    depends = depends.map{|d| url_depends(d)}

    ofp.write("You can also use the chart options for ")
    if depends.length > 2
        depends[0..-2].each {|d| ofp.write(d + ', ')}
        ofp.write('and ' + depends[-1])
    elsif depends.length > 1
        ofp.write(depends[0] + ' and ' + depends[1])
    else
        ofp.write(depends[0])
    end

    ofp.write(".\n\n")
end

# write accessor info
def write_accessors(ofp, accessors, func)

    ofp.write("### Accessors\n\n")

    accessors.each do |a|
        ofp.write("- `#{a[:name]}()` &mdash; #{a[:comment]}\n")
    end

    ofp.write("\n")

    if func != "add_lodcurve" # add_lodcurve is different :(
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
            write_depends(ofp, source_info[:depends])
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
