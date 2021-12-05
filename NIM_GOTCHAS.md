# Things I've Learned

---

If you use the following syntax:

```
for i, elem in arr:
    # etc
```

It may well compile to C, but the C won't compile to source code.

It turns out that this only does anything when the array contains pairs.

If you want to get the index alongside an element use:

```
for i, elem in arr.pairs:
    # etc
```

---

The language just lets your data get garbled apparently.

---
