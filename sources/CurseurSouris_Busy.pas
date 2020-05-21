unit CurseurSouris_Busy;


interface


procedure CurseurSouris_Busy_Begin;
procedure CurseurSouris_Busy_End;










implementation



uses Main,
     Controls {pour crHourGlass},
          MusicUser_PlusieursDocuments;




var private_actchild_cursor_ancien: integer = 0;




procedure CurseurSouris_Busy_Begin;
Begin
    MainForm.Cursor := crHourGlass;

    if MusicWriter_IsFenetreDocumentCourante then
    Begin
        private_actchild_cursor_ancien := actchild.Cursor;
        actchild.Cursor := crHourGlass;
    End;
End;





procedure CurseurSouris_Busy_End;
Begin
    MainForm.Cursor := crDefault;

    if MusicWriter_IsFenetreDocumentCourante then
         actchild.Cursor := private_actchild_cursor_ancien;
End;



end.
