function find(listModel, cond) {
    for (var i = 0; i < listModel.count; ++i)
        if (cond(listModel.get(i)))
            return i
    return null
}

function logSlider(x, min, max) {
    var minv = Math.log(min)
    var maxv = Math.log(max)
    var scale = (maxv - minv) / (max - min)
    return Math.exp(minv + scale * (x - min))
}
