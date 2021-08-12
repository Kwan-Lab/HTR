function setPrefix(obj,newPrefixText)
  % Give a char array that will become the prefix of the displayed updatable text.
  obj.prefix = newPrefixText;
  obj.print();
end