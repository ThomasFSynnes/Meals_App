class Rating{

  static List<int> ratingList = [];
  static List<String> idLsit = [];

  static void setRating(String id, int rating){
    ratingList.add(rating);
    idLsit.add(id);
  }

  static int getRating(String id){
    int index = idLsit.indexOf(id);
    return ratingList[index];
  }
}