# Things I've Learned

---

When running tests, if any file is imported that is higher up in your project than the test file, you will get an error.

Example folder structure:

```
src
    days
        file.zig
    utils
        filter.zig
```

If file.zig imports filter.zig, when you run `zig test src/days/day03.zig`, you get an error:

```
error: import of file outside package path: '../utils/filter.zig'
```

Solution: instead run:
```
zig test src/days/day03.zig --main-pkg-path src
```

---
