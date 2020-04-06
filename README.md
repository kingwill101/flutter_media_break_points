# media_break_points

Apply values per media breakpoints. Breakpoints are similar to the breakpoints used in 
bootstrap css framework.
https://getbootstrap.com/docs/4.1/layout/overview/#responsive-breakpoints

### example

```dart
Container c = Container(
    padding: valueFor<EdgeInsetGeometry>(
    context,
    xs:EdgeInsets.only(left: 25, right: 20),
    md:EdgeInsets.only(left: 25, right: 20),
    lg:EdgeInsets.only(left: 25, right: 20),
    )
);
```

```dart
double num = valueFor<double>(
  context, 
  xs:1,
  sm:2,
  md:3,
  lg:4,
  xl:4,
);
 ```
