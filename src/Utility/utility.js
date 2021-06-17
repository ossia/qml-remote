function find(listModel, cond) {
    for (var i = 0; i < listModel.count; ++i)
        if (cond(listModel.get(i)))
            return i
    return null
}

function logSlider(x, min, max) {
    const minv = Math.log(min)
    const maxv = Math.log(max)
    const range = max - min === 0
                ? 1
                : max - min
    const scale = (maxv - minv) / (max - min)
    return Math.exp(minv + scale * (x - min))
}
