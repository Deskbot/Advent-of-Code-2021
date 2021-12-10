# Things I've Learned

---

This local array `arr` holds `[3]i64`, you need to do `&arr` to get a `[]i64`.

```
const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() anyerror!void {
    var arr: [3]i64 = .{0,0,0};

    const result = sum(arr);  //bad
    const result = sum(&arr); //good

    _ = try stdout.print("{}\n", .{result});
}

fn sum(arr: []const i64) i64 {
    var result: i64 = 0 ;

    for (arr) |elem| {
        result += elem;
    }

    return result;
}
```

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

Array literals require a size.

If you want the size to be inferred use `[_]int64{ ... }`.

Don't use `.{}` for arrays.

You can't infer the size of a multidimensional array. `[_][_]int64 // BAD!`

---

If an assignment gets optimised out by the compiler because it's not used, the assignment doesn't have to be type correct for compilation to complete.

---
