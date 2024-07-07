import 'package:rocket_model/rocket_model.dart';

const String productIdField = "id";
const String productTitleField = "title";
const String productDescriptionField = "description";
const String productCategoryField = "category";
const String productPriceField = "price";
const String productDiscountpercentageField = "discountPercentage";
const String productRatingField = "rating";
const String productStockField = "stock";
const String productTagsField = "tags";
const String productBrandField = "brand";
const String productSkuField = "sku";
const String productWeightField = "weight";
const String productDimensionsField = "dimensions";
const String productWarrantyinformationField = "warrantyInformation";
const String productShippinginformationField = "shippingInformation";
const String productAvailabilitystatusField = "availabilityStatus";
const String productReviewsField = "reviews";
const String productReturnpolicyField = "returnPolicy";
const String productMinimumorderquantityField = "minimumOrderQuantity";
const String productMetaField = "meta";
const String productImagesField = "images";
const String productThumbnailField = "thumbnail";

class Product extends RocketModel<Product> {
  int? id;
  String? title;
  String? description;
  String? category;
  double? price;
  double? discountpercentage;
  double? rating;
  int? stock;
  List<String>? tags;
  String? brand;
  String? sku;
  int? weight;
  Dimensions? dimensions;
  String? warrantyinformation;
  String? shippinginformation;
  String? availabilitystatus;
  Reviews? reviews;
  String? returnpolicy;
  int? minimumorderquantity;
  Meta? meta;
  List<String>? images;
  String? thumbnail;

  Product({
    this.id,
    this.title,
    this.description,
    this.category,
    this.price,
    this.discountpercentage,
    this.rating,
    this.stock,
    this.tags,
    this.brand,
    this.sku,
    this.weight,
    this.dimensions,
    this.warrantyinformation,
    this.shippinginformation,
    this.availabilitystatus,
    this.reviews,
    this.returnpolicy,
    this.minimumorderquantity,
    this.meta,
    this.images,
    this.thumbnail,
  }) {
    dimensions ??= Dimensions();
    reviews ??= Reviews();
    meta ??= Meta();
  }

  @override
  void fromJson(Map<String, dynamic>? json, {bool isSub = false}) {
    if (json == null) return;
    id = json[productIdField];
    title = json[productTitleField];
    description = json[productDescriptionField];
    category = json[productCategoryField];
    price = json[productPriceField];
    discountpercentage = json[productDiscountpercentageField];
    rating = json[productRatingField];
    stock = json[productStockField];
    tags = json[productTagsField];
    brand = json[productBrandField];
    sku = json[productSkuField];
    weight = json[productWeightField];
    dimensions!.fromJson(json[productDimensionsField]);
    warrantyinformation = json[productWarrantyinformationField];
    shippinginformation = json[productShippinginformationField];
    availabilitystatus = json[productAvailabilitystatusField];
    reviews!.setMulti(json['reviews']);
    returnpolicy = json[productReturnpolicyField];
    minimumorderquantity = json[productMinimumorderquantityField];
    meta!.fromJson(json[productMetaField]);
    images = json[productImagesField];
    thumbnail = json[productThumbnailField];
    super.fromJson(json, isSub: isSub);
  }

  void updateFields({
    int? idField,
    String? titleField,
    String? descriptionField,
    String? categoryField,
    double? priceField,
    double? discountpercentageField,
    double? ratingField,
    int? stockField,
    List<String>? tagsField,
    String? brandField,
    String? skuField,
    int? weightField,
    Dimensions? dimensionsField,
    String? warrantyinformationField,
    String? shippinginformationField,
    String? availabilitystatusField,
    Reviews? reviewsField,
    String? returnpolicyField,
    int? minimumorderquantityField,
    Meta? metaField,
    List<String>? imagesField,
    String? thumbnailField,
  }) {
    id = idField ?? id;
    title = titleField ?? title;
    description = descriptionField ?? description;
    category = categoryField ?? category;
    price = priceField ?? price;
    discountpercentage = discountpercentageField ?? discountpercentage;
    rating = ratingField ?? rating;
    stock = stockField ?? stock;
    tags = tagsField ?? tags;
    brand = brandField ?? brand;
    sku = skuField ?? sku;
    weight = weightField ?? weight;
    dimensions = dimensionsField ?? dimensions;
    warrantyinformation = warrantyinformationField ?? warrantyinformation;
    shippinginformation = shippinginformationField ?? shippinginformation;
    availabilitystatus = availabilitystatusField ?? availabilitystatus;
    reviews = reviewsField ?? reviews;
    returnpolicy = returnpolicyField ?? returnpolicy;
    minimumorderquantity = minimumorderquantityField ?? minimumorderquantity;
    meta = metaField ?? meta;
    images = imagesField ?? images;
    thumbnail = thumbnailField ?? thumbnail;
    rebuildWidget(fromUpdate: true);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[productIdField] = id;
    data[productTitleField] = title;
    data[productDescriptionField] = description;
    data[productCategoryField] = category;
    data[productPriceField] = price;
    data[productDiscountpercentageField] = discountpercentage;
    data[productRatingField] = rating;
    data[productStockField] = stock;
    data[productTagsField] = tags;
    data[productBrandField] = brand;
    data[productSkuField] = sku;
    data[productWeightField] = weight;
    data[productDimensionsField] = dimensions!.toJson();
    data[productWarrantyinformationField] = warrantyinformation;
    data[productShippinginformationField] = shippinginformation;
    data[productAvailabilitystatusField] = availabilitystatus;
    data[productReviewsField] = reviews!.all!.map((e) => e.toJson()).toList();
    data[productReturnpolicyField] = returnpolicy;
    data[productMinimumorderquantityField] = minimumorderquantity;
    data[productMetaField] = meta!.toJson();
    data[productImagesField] = images;
    data[productThumbnailField] = thumbnail;

    return data;
  }

  @override
  get instance => Product();
}

const String metaCreatedatField = "createdAt";
const String metaUpdatedatField = "updatedAt";
const String metaBarcodeField = "barcode";
const String metaQrcodeField = "qrCode";

class Meta extends RocketModel<Meta> {
  String? createdat;
  String? updatedat;
  String? barcode;
  String? qrcode;

  Meta({
    this.createdat,
    this.updatedat,
    this.barcode,
    this.qrcode,
  });

  @override
  void fromJson(Map<String, dynamic>? json, {bool isSub = false}) {
    if (json == null) return;
    createdat = json[metaCreatedatField];
    updatedat = json[metaUpdatedatField];
    barcode = json[metaBarcodeField];
    qrcode = json[metaQrcodeField];
    super.fromJson(json, isSub: isSub);
  }

  void updateFields({
    String? createdatField,
    String? updatedatField,
    String? barcodeField,
    String? qrcodeField,
  }) {
    createdat = createdatField ?? createdat;
    updatedat = updatedatField ?? updatedat;
    barcode = barcodeField ?? barcode;
    qrcode = qrcodeField ?? qrcode;
    rebuildWidget(fromUpdate: true);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[metaCreatedatField] = createdat;
    data[metaUpdatedatField] = updatedat;
    data[metaBarcodeField] = barcode;
    data[metaQrcodeField] = qrcode;

    return data;
  }
}

const String reviewsRatingField = "rating";
const String reviewsCommentField = "comment";
const String reviewsDateField = "date";
const String reviewsReviewernameField = "reviewerName";
const String reviewsRevieweremailField = "reviewerEmail";

class Reviews extends RocketModel<Reviews> {
  int? rating;
  String? comment;
  String? date;
  String? reviewername;
  String? revieweremail;

  Reviews({
    this.rating,
    this.comment,
    this.date,
    this.reviewername,
    this.revieweremail,
  });

  @override
  void fromJson(Map<String, dynamic>? json, {bool isSub = false}) {
    if (json == null) return;
    rating = json[reviewsRatingField];
    comment = json[reviewsCommentField];
    date = json[reviewsDateField];
    reviewername = json[reviewsReviewernameField];
    revieweremail = json[reviewsRevieweremailField];
    super.fromJson(json, isSub: isSub);
  }

  void updateFields({
    int? ratingField,
    String? commentField,
    String? dateField,
    String? reviewernameField,
    String? revieweremailField,
  }) {
    rating = ratingField ?? rating;
    comment = commentField ?? comment;
    date = dateField ?? date;
    reviewername = reviewernameField ?? reviewername;
    revieweremail = revieweremailField ?? revieweremail;
    rebuildWidget(fromUpdate: true);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[reviewsRatingField] = rating;
    data[reviewsCommentField] = comment;
    data[reviewsDateField] = date;
    data[reviewsReviewernameField] = reviewername;
    data[reviewsRevieweremailField] = revieweremail;

    return data;
  }

  @override
  get instance => Reviews();
}

const String dimensionsWidthField = "width";
const String dimensionsHeightField = "height";
const String dimensionsDepthField = "depth";

class Dimensions extends RocketModel<Dimensions> {
  double? width;
  double? height;
  double? depth;

  Dimensions({
    this.width,
    this.height,
    this.depth,
  });

  @override
  void fromJson(Map<String, dynamic>? json, {bool isSub = false}) {
    if (json == null) return;
    width = json[dimensionsWidthField];
    height = json[dimensionsHeightField];
    depth = json[dimensionsDepthField];
    super.fromJson(json, isSub: isSub);
  }

  void updateFields({
    double? widthField,
    double? heightField,
    double? depthField,
  }) {
    width = widthField ?? width;
    height = heightField ?? height;
    depth = depthField ?? depth;
    rebuildWidget(fromUpdate: true);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[dimensionsWidthField] = width;
    data[dimensionsHeightField] = height;
    data[dimensionsDepthField] = depth;

    return data;
  }
}
