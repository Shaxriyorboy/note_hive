class Notes{
  int? id;
  String? name;
  String? date;
  String? editDate;
  String? note;
  bool? isSelected;

  Notes({this.name,this.date,this.note,this.isSelected = false,this.editDate,this.id});

  Notes.fromJson(Map<String,dynamic> json)
      : name = json["name"],
        id = json["id"],
        date = json["date"],
        note = json["note"],
        isSelected = json["isSelected"],
        editDate = json["editDate"];

  Map<String, dynamic> toJson() => {
    "name" : name,
    "id" : id,
    "date" : date,
    "note" : note,
    "isSelected" : isSelected,
    "editDate" : editDate,
  };
}