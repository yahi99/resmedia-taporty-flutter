//import 'package:flutter/widgets.dart';
//import 'package:easy_blocs/easy_blocs.dart';
//import 'package:flutter_google_places/flutter_google_places.dart';
//import 'package:geocoder/geocoder.dart';
//
//
//abstract class GeoFieldBone implements FieldBone<List<Address>> {
//
//}
//
//
//class GeoFieldSkeleton extends FieldSkeleton<List<Address>> implements GeoFieldBone {
//
//}
//
//
//class GeoFieldShell extends StatefulWidget implements FocusShell {
//  final GeoFieldBone bone;
//
//  final String apiKey;
//
//  @override
//  final MapFocusBone mapFocusBone;
//  @override
//  final FocusNode focusNode;
//
//  const GeoFieldShell({Key key, this.mapFocusBone, this.focusNode}) : super(key: key);
//
//  @override
//  _GeoFieldShellState createState() => _GeoFieldShellState();
//}
//
//class _GeoFieldShellState extends State<GeoFieldShell> with FocusShellStateMixin {
//  @override
//  Widget build(BuildContext context) {
//
//    return PlacesAutocompleteFormField(
//      apiKey: widget.apiKey,
//      validator: (address) {
//
//      },
//      onSaved: (address) async {
//        widget.bone.value = await Geocoder.local.findAddressesFromQuery(address);
//      },
//    );
//  }
//}
