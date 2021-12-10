pub fn all(bools: []const bool) bool {
    for (bools) |b| {
        if (!b) {
            return false;
        }
    }

    return true;
}
