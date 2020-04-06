# media_break_points

Apply values per media breakpoints

###example

```dart
Container c = Container(
    padding: valueFor<EdgeInsetGeometry>(
    xs:EdgeInsets.only(left: 25, right: 20),
    md:EdgeInsets.only(left: 25, right: 20),
    lg:EdgeInsets.only(left: 25, right: 20),
    );
);
 ```