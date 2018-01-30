String[] form;
  boolean oldPrompt = false;
Button update;

void checkUpdate() {
  form = loadStrings("https://docs.google.com/spreadsheets/d/14w1Afy2NJtc6vK4i_3BjnLKG24dW3gvTb0vVyaZ1Fhw/edit?usp=sharing");
  String latestVer = trim(form[2].substring(0, 15));
  latestVer = latestVer.substring(0, 7) + latestVer.substring(8, 11) + latestVer.substring(12);

  int[] latest = {int(latestVer.substring(4, 6)), int(latestVer.substring(7, 9)), int(latestVer.substring(10, 12))};
  int[] current = {int(VERSION.substring(4, 6)), int(VERSION.substring(7, 9)), int(VERSION.substring(10, 12))};

  
  if (current[0] >= latest[0]) {
    if (current[1] >= latest[1]) {
      if (!(current[2] >= latest[2])) oldPrompt = true;
    } else oldPrompt = true;
  } else oldPrompt = true;
  
  if (oldPrompt) update.updateGreyOut(false); 
  else update.updateGreyOut(true);
}