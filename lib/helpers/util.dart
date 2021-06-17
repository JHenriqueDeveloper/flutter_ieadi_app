

String firstName(String fullName) => fullName?.substring(0, fullName.indexOf(' ')) ?? '';