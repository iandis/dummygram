
class Validators{
  Validators();
  bool isValidEmail(String value) {
    if(value == null) return false;
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }
  bool isValidUsername(String value){
    Pattern pattern = r'^[a-zA-Z0-9\_]+$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(value);
  }
  int isValidPassword(String input){
    if(input==null) return -1;
    if(input.length==0) return -1;
    String output = input.replaceAll(" ", "");
    if(output == "") return -1;
    if(input.length<8) return 0;
    return 1;
  }
  bool isNullOrWhitespace(String input) {
    if(input==null) return true;
    if(input.length==0) return true;
    String output = input.replaceAll(" ", "");
    if(output == "") return true;
    return false;
  }
}