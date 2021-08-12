function printAbove(obj,text)
  % Print a non-updatable line above the displayed UpdatableText.

  assert(ischar(text),'Given argument must be a char array');
  obj.erase();
  fprintf([text '\n']);
  obj.print();
end