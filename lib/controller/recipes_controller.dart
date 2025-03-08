import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:idc_etus_bechar/services/api_services_admin.dart';
import 'package:idc_etus_bechar/models/bus_trip.dart';

class BusTripController extends GetxController {
  final ApiServicesAdmin busTripService = ApiServicesAdmin();
  var _busTrips = <BusTrip>[].obs;
  var _isLoading = false.obs;
  var _errorMessage = ''.obs;
  final _filteredRecipes = Rx<List<BusTrip>>([]);
  var _selectedStartDate = Rx<DateTime?>(null);
  var _selectedEndDate = Rx<DateTime?>(null);
  bool isDataFetched = false;
  var _recipeCount = 0.obs;

  int get recipeCount => _recipeCount.value;

  set recipeCount(int count) {
    _recipeCount.value = count;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    fetchBusTrips();
  }

  List<BusTrip> get busTrips => _busTrips;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  DateTime? get selectedStartDate => _selectedStartDate.value;
  List<BusTrip> get filteredRecipes => _filteredRecipes.value;

  set selectedStartDate(DateTime? newDate) {
    _selectedStartDate.value = newDate;
    update();
  }

  DateTime? get selectedEndDate => _selectedEndDate.value;

  set selectedEndDate(DateTime? newDate) {
    _selectedEndDate.value = newDate;
    update();
  }

  Future<void> fetchBusTrips() async {
    final busId = int.tryParse(Get.arguments as String? ?? '') ?? 0;
    if (isDataFetched) return;
    if (busId == 0) {
      _errorMessage.value = 'Invalid bus ID';
      return;
    }

    _isLoading.value = true;

    try {
      final busTrips = await busTripService.fetchTripBus(busId);
      _busTrips.value = busTrips;
      if (busTrips.isNotEmpty) {
        _selectedEndDate.value = DateTime.tryParse(busTrips.first.endDate ?? '');
        _selectedStartDate.value = DateTime.tryParse(busTrips.first.startDate ?? '');
      } else {
        _selectedEndDate.value = null;
        _selectedStartDate.value = null;
      }

      isDataFetched = true;
    } catch (error) {
      _errorMessage.value = 'Failed to fetch bus trips: $error';
      print('Error fetching trips: $error');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> fetchFilteredRecipes(DateTime startDate, DateTime endDate, {int? filterId}) async {
    _isLoading.value = true;
    update();

    final fromDate = startDate.toIso8601String();
    final toDate = endDate.toIso8601String();

    print('Fetching recipes with dates: From $fromDate To $toDate');
    print('Filter ID (busId): $filterId');

    try {
      final recipes = await busTripService.fetchFilteredRecipes(fromDate, toDate);
      print('Fetched recipes from service: $recipes');
      if (filterId != null) {
        _filteredRecipes.value = recipes.where((recipe) => recipe.busId == filterId).toList();
        print('Filtered recipes fetched: ${_filteredRecipes.value}');
      } else {
        _filteredRecipes.value = recipes;
      }
      final recipeCount = _filteredRecipes.value.length;
      print('Filtered recipes fetched: ${_filteredRecipes.value}');
      print('Number of filtered recipes: $recipeCount');
      if (_filteredRecipes.value.isEmpty) {
        _errorMessage.value = 'No recipes found for the selected filter.';
      }
      _recipeCount.value = recipeCount;
    } catch (error) {
      _errorMessage.value = 'Failed to fetch filtered recipes: $error';
      print('Error fetching recipes: $error');
    } finally {
      _isLoading.value = false;
      update();
    }
  }
}
