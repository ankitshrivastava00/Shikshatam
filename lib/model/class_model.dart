class ClassModel{
  String Name;
  int i;
  ClassModel(this.i,this.Name);
  static List<ClassModel> getCompanies() {
    return <ClassModel>[
      ClassModel(0, 'select Class' ),
      ClassModel(1, '1' ),
      ClassModel(2, '2'),
      ClassModel(3, '3'),
      ClassModel(4, '4'),
      ClassModel(5, '5'),
      ClassModel(6, '6'),
      ClassModel(7, '7'),
      ClassModel(8, '8'),
      ClassModel(9, '9'),
      ClassModel(10, '10'),
      ClassModel(11, '11'),
      ClassModel(12, '12'),
    ];
  }
}