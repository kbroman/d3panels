## `lodchart`

Plot a lod curve.

### Example

```coffeescript
data = {chr:[1,1,1,1,2,2,2], pos:[0,5,10,20,0,8,12],lod:[0.42,1.69,1.65,2.94,0.17,0.15,0.07], marker:["1-1","1-2","","1-3","2-1","","2-2"]}

mychart = d3panels.lodchart({height:300, width:600})
mychart(d3.select('body'), data)
```

**insert_chartOpts**

**insert_accessors**
