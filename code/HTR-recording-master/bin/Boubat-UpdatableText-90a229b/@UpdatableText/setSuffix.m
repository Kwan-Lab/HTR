function setSuffix(obj,newSuffixText)
  % Give a char array that will become the suffix of the displayed updatable text.
  obj.suffix = newSuffixText;
  obj.print();
end