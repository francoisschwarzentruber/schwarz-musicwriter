unit utils;

interface

Function boolToStr(b:Boolean):string;

implementation

Function boolToStr(b:Boolean):string;
Begin
    if b then
     result := 'vrai'
    else
     result := 'faux';
end;

end.
