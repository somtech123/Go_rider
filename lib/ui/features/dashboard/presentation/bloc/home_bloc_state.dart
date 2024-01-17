// ignore_for_file: override_on_non_overriding_member

import 'dart:async';

import 'package:go_rider/app/helper/local_state_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePageState {
  LoadingState? loadingState;
  LatLng? currentLocation;
  Completer<GoogleMapController> mapController;
  //  =
  //

  HomePageState(
      {this.loadingState = LoadingState.initial,
      this.currentLocation,
      required this.mapController});

  HomePageState copyWith({
    LoadingState? loadingState,
    LatLng? currentLocation,
    Completer<GoogleMapController>? mapController,
  }) =>
      HomePageState(
          loadingState: loadingState ?? this.loadingState,
          currentLocation: currentLocation ?? this.currentLocation,
          mapController: mapController ?? this.mapController);

  @override
  List<Object?> get props => [loadingState, currentLocation, mapController];
}
