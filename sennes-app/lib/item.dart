import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

// Call "flutter packages pub run build_runner build" in command line after chaning this class
@JsonSerializable()
class Item extends Comparable<Item> {
  String barcode;
  String name;
  String imageUrl;
  String thumbnail;
  String size;
  String manufacturerNote;
  String website;
  String brand;
  int amount;
  List<DateTime> changed;
  List<dynamic> ingredients;
  Map<String, dynamic> nutriments;
  bool dataComplete;

  Item({
    this.barcode,
    this.name,
    this.amount = 1,
    this.size = '',
    this.imageUrl,
    this.thumbnail,
    this.manufacturerNote = 'No information provided',
    this.changed,
    this.website = '',
    this.brand = '',
    this.dataComplete = false,
    this.ingredients,
    this.nutriments,
  }) {
    changed = changed ?? [DateTime.now()];
  }

  readUpdate(Map<String, dynamic> update, key, missing) {
    return update.containsKey(key) ? update[key] : missing;
  }

  void updateInfo(Map<String, dynamic> update) {
    this.name = readUpdate(update, 'product_name', this.name);
    this.imageUrl = readUpdate(update, 'image_url', this.imageUrl);
    this.thumbnail = readUpdate(update, 'image_thumb_url', this.thumbnail);
    this.size = readUpdate(update, 'quantity', this.size);
    this.manufacturerNote =
        readUpdate(update, 'usage', this.manufacturerNote);
    this.ingredients = readUpdate(update, 'ingredients', this.ingredients);
    this.website = readUpdate(update, 'product_web_page', this.website);
    this.nutriments = readUpdate(update, 'nutriments', this.nutriments);
    this.brand = readUpdate(update, 'brands', this.brand);
    this.dataComplete = true;
  }

  @override
  int compareTo(Item other) {
    return this.displayName.toLowerCase().compareTo(other.displayName.toLowerCase());
  }

  get identifier {
    return barcode ?? name.toLowerCase();
  }

  get titleName {
    var result = fullName;
    return result.length > 20 ? name : result;
  }

  get displayName {
    return name ?? barcode;
  }

  get fullName {
    if (name != null) {
      if (brand != "" && brand != null) {
        return "$brand $name";
      }
      return name;
    }
    return barcode;
  }

  DateTime get addedDate {
    return changed.length == 0 ? DateTime.now() : changed.last;
  }

  String get dateString {
    final now = DateTime.now();
    final last = addedDate.toLocal();
    final diff = now.difference(last);
    if (diff.inMinutes < 1)
      return "just now";
    if (diff.inHours < 1)
      return "${diff.inMinutes}m ago";
    if (diff.inDays < 1)
      return "${diff.inHours}h ago";
    if (diff.inDays < 7)
      return "${diff.inDays}d ago";
    if (diff.inDays < 30)
      return "${diff.inDays~/7}w ago";
    return DateFormat("dd.MM.yy").format(last);
  }

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);

  bool operator ==(o) => o is Item && identifier == o.identifier;
  int get hashCode => identifier.hashCode;
}
