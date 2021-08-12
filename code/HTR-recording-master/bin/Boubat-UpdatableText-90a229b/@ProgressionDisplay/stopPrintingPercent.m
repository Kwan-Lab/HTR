function stopPrintingPercent(obj)
  % Remove the percentText from the displayed text.

  obj.percentTextIsPrinted = false;
  obj.print();
end