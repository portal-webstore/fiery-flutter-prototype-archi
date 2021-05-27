import 'package:fiery_flutter_prototype_archi/order/review_historical_order/molecules/patient_treatment_product_list_item.dart'
    show PatientTreatmentProductListItem;
import 'package:fiery_flutter_prototype_archi/order/review_historical_order/seeds/patient_treatment_products_seed.dart'
    show seedPatientTreatmentProducts;
import 'package:fiery_flutter_prototype_archi/shared/drawer/drawer.dart'
    show SideMenuNavigationDrawer;
import 'package:flutter/material.dart';
import 'package:order_repository/order_repository.dart'
    show
        FirebaseOrderRepository,
        OrderRepository,
        Order,
        PatientTreatmentProductItem,
        ProductDescription;
import 'package:patient_repository/patient_repository.dart'
    show Patient, PatientBirthDateAustralian;

/// Review the multiple patients + products within a single consolidated order
class ReviewHistoricalOrderScreen extends StatefulWidget {
  const ReviewHistoricalOrderScreen({
    Key? key,
    required this.orderID,
    required this.clinicID,
  }) : super(key: key);

  static const title = 'Review ordered patient treatments';

  static Page page({
    String orderID = '',
    String clinicID = '',
  }) =>
      MaterialPage<void>(
        child: ReviewHistoricalOrderScreen(
          orderID: orderID,
          clinicID: clinicID,
        ),
      );

  static Route<void> route({
    String orderID = '',
    String clinicID = '',
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => ReviewHistoricalOrderScreen(
        orderID: orderID,
        clinicID: clinicID,
      ),
    );
  }

  /// Quick hacky solution
  /// Our quick validator to make sure the untyped route settings are valid
  /// for use in review order details screen
  static Map<String, String>? getValidatedRouteParamsArgs(Object? args) {
    if (args == null) {
      return null;
    }
    try {
      final Map<String, String?> navParams = args as Map<String, String?>;

      // May throw runtime type errors on access instead of exception?
      final String clinic = navParams['clinicID'] ?? '';
      final String orderID = navParams['orderID'] ?? '';

      if (clinic.isEmpty || orderID.isEmpty) {
        throw const FormatException(
          'Invalid route details for order review',
        );
      }

      return navParams as Map<String, String>;
    } on Exception catch (exception) {
      print(
        'Unable to retrieve query information for route order details '
        '${exception.toString()}',
      );
    }
    return null;
  }

  final String orderID;
  final String clinicID;

  @override
  _ReviewHistoricalOrderScreenState createState() =>
      _ReviewHistoricalOrderScreenState();
}

class _ReviewHistoricalOrderScreenState
    extends State<ReviewHistoricalOrderScreen> {
  late final OrderRepository _orderRepository;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _load() {
    _orderRepository = FirebaseOrderRepository(
      clinicID: widget.clinicID,
    );

    _orderRepository
        .addNewOrder(
          Order(
            orderID: '',
            orderReference: 'orderReference free text',
            createdAt: DateTime.now().millisecondsSinceEpoch,
            updatedAt: DateTime.now().millisecondsSinceEpoch,
            requiredByDeliveryDate: '2021-05-20',
            comments: 'comments',
            isDraft: true,
            patientTreatmentProductItems: seedPatientTreatmentProducts,
          ),
        )
        .onError((error, stackTrace) => print)
        .catchError(
      () {
        print('add new order error');
      },
    ).then((value) {
      print('wahoo order added');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ReviewHistoricalOrderScreen.title,
        ),
        actions: const <Widget>[],
      ),
      drawer: const SideMenuNavigationDrawer(),
      body: FutureBuilder(
        builder: (
          BuildContext context,
          AsyncSnapshot<Order?> snapshot,
        ) {
          final Order? dartLangNullabilityBlankedOrder = snapshot.data;
          if (dartLangNullabilityBlankedOrder == null || !snapshot.hasData) {
            return const CircularProgressIndicator.adaptive();
          }

          final Order order = dartLangNullabilityBlankedOrder;
          final List<PatientTreatmentProductItem> items =
              order.patientTreatmentProductItems;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              final item = items[index];

              return PatientTreatmentProductListItem(
                treatmentProductStatusCode: item.status,
                patientNameTitleLine: item.patient.getNameTextFromPatient(),
                multiProductAndQuantityContentLines:
                    item.getQuantifiedDosedProductText(),
              );
            },
            itemCount: items.length,
          );
        },
        future: _orderRepository.getOrder(widget.orderID),
      ),
    );
  }

  List<Widget> _getSeedListItems() {
    final List<ListItemAdaptedFromPatientTreatmentProduct> listItems =
        seedPatientTreatmentProducts
            .map(
              (
                PatientTreatmentProductItem e,
              ) =>
                  ListItemAdaptedFromPatientTreatmentProduct(
                patientTreatmentProductItem: e,
              ),
            )
            .toList();

    return listItems;
  }
}

class ListItemAdaptedFromPatientTreatmentProduct extends StatelessWidget {
  const ListItemAdaptedFromPatientTreatmentProduct({
    Key? key,
    required this.patientTreatmentProductItem,
  }) : super(key: key);

  final PatientTreatmentProductItem patientTreatmentProductItem;
  @override
  Widget build(BuildContext context) {
    return PatientTreatmentProductListItem(
      treatmentProductStatusCode: patientTreatmentProductItem.status,
      patientNameTitleLine:
          patientTreatmentProductItem.patient.getNameTextFromPatient(),
      multiProductAndQuantityContentLines:
          patientTreatmentProductItem.getQuantifiedDosedProductText(),
    );
  }
}
