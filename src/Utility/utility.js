function find(listModel, cond) {
    for (var i = 0; i < listModel.count; ++i)
        if (cond(listModel.get(i)))
            return i
    return null
}
