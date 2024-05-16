class getSavingsModel {
  int id = 0 ;
  String? memberID;
  String? memberName;
  String? amount;
  String? dateNow;
  String? contributionType;
  String? branch;
  String? agentID;
  String? dateTime;
  String? transactionType;
  String ? agentUsername;

  getSavingsModel(
      this.id,
      this.memberID,
      this.memberName,
      this.amount,
      this.agentID,
      this.branch,
      this.contributionType,
      this.transactionType,
      this.dateTime,
      this.dateNow,
      this.agentUsername,
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id' : id,
      'memberID': memberID,
      'memberName': memberName,
      'amount': amount,
      'agentID': agentID,
      'branch': branch,
      'contributionType': contributionType,
      'transactionType': transactionType,
      'dateTime': dateTime,
      'dateNow': dateNow,
      'agentUsername': agentUsername,
    };
    return map;
  }

  getSavingsModel.fromMap(Map<String, dynamic> map) {
    id = map['id'] ;
    memberID = map['memberID'];
    memberName = map['memberName'];
    amount = map['amount'];
    agentID = map['agentID'];
    branch = map['branch'];
    contributionType = map['contributionType'];
    transactionType = map['transactionType'];
    dateTime = map['dateTime'];
    dateNow = map['dateNow'];
    agentUsername = map['agentUsername'];
  }
}
