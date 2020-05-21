unit Entree_WaveIn_FFT;


interface


uses Entree_WaveIn_Signal_Type, Math;


const FFT_Bit = Entree_WaveIn_Tampon_NbEchantillons_NbBitsChiffre;
      FFT_Echantillons = 1 shl FFT_Bit;
      N_EchCompresse = FFT_Echantillons;
      //FFT_FreqBase = N_Echantillonnage / FFT_Echantillons;
      FFT_MaxIFreq = FFT_Echantillons div 2-1;



type TSpectre = array[0..FFT_Echantillons-1] of real;
     TSpectrePuiss = array[0..FFT_MaxIFreq] of real;
     TPicsTab = array of integer;

procedure fft(iDebut:   integer;
    var  Signal: TEntree_Wavein_Signal;
    var  SortieR:  TSpectre;
    var  SortieI:  TSpectre);

Procedure CreerSpectrePuiss(SpectreR, SpectreI: TSpectre; var spuiss:TSpectrePuiss);
Function FreqFondamental(var sp:TSpectrePuiss): real;
Function TesterFreq(var sp:TSpectrePuiss; freq: real): real;
Function Frequence_DansSpectre_Evaluer(var sp:TSpectrePuiss; freq: real): real;


implementation



function InverserBits ( index, NumBits: integer ): integer;
var     i, rev: integer;
begin
    rev := 0;
    for i := 0 to NumBits-1 do begin
        rev := (rev SHL 1) OR (index AND 1);
        index := index SHR 1;
    end;

    result := rev;

end;





procedure fft (iDebut: integer; var  Signal:   TEntree_Wavein_Signal;
                                  var  SortieR:  TSpectre;
                                  var  SortieI:  TSpectre);
var
    i, j, k, BlockSize, BlockEnd: integer;
    delta_angle, delta_ar: double;
    alpha, beta: double;
    tr, ti, ar, ai: double;


begin
    {Recopie le tableau à analyser dans l'ordre inverse "binairement"}
    for i := 0 to FFT_Echantillons-1 do begin
        j := InverserBits(i, FFT_Bit);

        SortieR[j] := Signal[iDebut + i];
        SortieI[j] := 0;
    end;

    BlockEnd := 1;
    {BlockEnd est l'ancienne valeur de BlockSize, ie la puissance de 2 précédente}
    BlockSize := 2;
    {BlockSize commence à 2, et incrémentera de puissance de 2 en puissance de
        2, jusqu'à NumSamples}
    while BlockSize <= FFT_Echantillons do begin
        delta_angle := 2*PI / BlockSize;
        alpha := sin ( 0.5 * delta_angle );
        alpha := 2.0 * alpha * alpha;
        //alpha = 1 - cos(delta_angle)
        beta := sin ( delta_angle );

        i := 0;
        {à chaque valeur de BlockSize, i va parcourir l'ensemble des multiples
          de BlockSize jusqu'à NumSamples}
        while i < FFT_Echantillons do begin
            ar := 1.0;    (* cos(0) *)
            ai := 0.0;    (* sin(0) *)

            for j := i to i+BlockEnd-1 do begin
                k := j + BlockEnd;
                //t := a * out[k] 
                tr := ar*SortieR[k] - ai*SortieI[k];
                ti := ar*SortieI[k] + ai*SortieR[k];
                SortieR[k] := SortieR[j] - tr;
                SortieI[k] := SortieI[j] - ti;
                SortieR[j] := SortieR[j] + tr;
                SortieI[j] := SortieI[j] + ti;
                delta_ar := alpha*ar + beta*ai;
                ai := ai - (alpha*ai - beta*ar);
                ar := ar - delta_ar;
            end;

            i := i + BlockSize;
        end;

        BlockEnd := BlockSize;
        BlockSize := BlockSize SHL 1; //on multiplie par 2 BlockSize
    end;

    for j := 0 to FFT_Echantillons-1 do
    Begin
        SortieR[j] := SortieR[j]/FFT_Echantillons;
        SortieI[j] := SortieI[j]/FFT_Echantillons;
    End;

end;




Function FFT_FreqBase_Get: real;
Begin
     result := 22050 / FFT_Echantillons;
End;


Function FFT_iToFreq(i: integer): real;
Begin
    result := 22050 * i / FFT_Echantillons;
End;

Procedure CreerSpectrePuiss(SpectreR, SpectreI: TSpectre; var spuiss:TSpectrePuiss);
var j:integer;
Begin
for j := 0 to FFT_Echantillons div 2-1 do
    spuiss[j] := (sqr(SpectreR[j]) + sqr(SpectreI[j])
                                 + sqr(SpectreR[FFT_Echantillons-j-1]) + sqr(SpectreI[FFT_Echantillons-j-1])) / 500;

End;







Function FreqFondamental(var sp:TSpectrePuiss): real;
const nmaxharmo = 10;
      eprec = 0.2;
      seuilsonore = 10;
      seuilsonoresp = 0;

var pics: array of integer;
    poids: array of real;
    i, iminfreq, imaxfreq,
    j, jmaxpic, jmaxpoids,
    k, f, numharmo :integer;
    maxpoids, r, e: real;
    freq: array of real;
    sommeFreq: real;
    lastnumharmo, lastvolmaxvol: real;
    FFT_FreqBase: real;
Begin

      j := -1;
      FFT_FreqBase := FFT_FreqBase_Get;
      iminfreq := round(50 / FFT_FreqBase);
      imaxfreq := round(4000 / FFT_FreqBase);

      For i := iminfreq to imaxfreq do
             if (sp[i] - sp[i-1] >= 0) and (sp[i] - sp[i+1] >=0) and (sp[i] > seuilsonore) then
                       Begin
                           inc(j);
                           setlength(pics,j+1);
                           pics[j] := i;

                       End;


      setlength(poids, length(pics));

      jmaxpic := high(pics);

      if jmaxpic = -1 then
          Begin
              result := 0;
              Exit;
          End;

      for j := 0 to jmaxpic do
             Begin
                 poids[j] := sp[pics[j]];

                 for k := j+1 to jmaxpic do
                        Begin
                             r := pics[k] / pics[j];
                             e := r - round(r);
                             poids[j] := poids[j] + power(1 - abs(e),4) * sp[pics[k]];
                        End;


             End;

      maxpoids := 0;
      jmaxpoids := 0;

      for j := 0 to jmaxpic do
            Begin
                   if poids[j] > maxpoids then
                   Begin
                          maxpoids := poids[j];
                          jmaxpoids := j;
                   End;


            End;

      j := jmaxpoids;

      f := -1;

      lastnumharmo := 0;
      result := pics[j] * FFT_FreqBase;
      for k := j+1 to jmaxpic do
            Begin

                  r := pics[k] / pics[j];
                  numharmo := round(r);
                  if numharmo <> lastnumharmo then
                  Begin
                     lastvolmaxvol := 0;
                     lastnumharmo := numharmo;
                  End;
                  e := r - round(r);
                  if abs(e) <= eprec then
                        Begin

                            if (sp[pics[k]] > lastvolmaxvol) and (sp[pics[k]] > seuilsonoresp) then
                            Begin

                                 inc(f);
                                 setlength(freq, f+1);
                                 freq[f] := pics[k] * FFT_FreqBase / numharmo;
                                 lastvolmaxvol := sp[pics[k]];
                                 result := pics[k] * FFT_FreqBase / numharmo;
                            end;
                        End;
            End;



      sommeFreq := pics[j]* FFT_FreqBase;


      for f := 0 to high(Freq) do
              sommeFreq := sommeFreq + Freq[f];



      result := sommeFreq / (length(Freq) + 1);




End;






Function Frequence_DansSpectre_Evaluer(var sp:TSpectrePuiss; freq: real): real;
const frequence_tolerance = 0.05;
      facteur_mauvaise_frequence = 10;
      facteur_mauvaise_frequence_sous_harmonique_fondamentale = 200;
      facteur_bonne_frequence_premiere_harmonique = 100;
      facteur_bonne_frequence = 5;

var i: integer;
    evaluation: real;
    harmonique_hypothetique_numero: integer;
    frequence_en_i: real;


    Function BonneFrequence: Boolean;
    Begin
        result := abs((frequence_en_i - freq * harmonique_hypothetique_numero) /
                    (freq * harmonique_hypothetique_numero)) < frequence_tolerance;
    End;



    Function FacteurBonneFrequenceSelonHarmoniqueNumero(harmonique_numero: integer): real;
    Begin
        case harmonique_numero of
              1: result := 5;
              2: result := 2;
              3: result := 1;
              4: result := 0.2;
              else result := 0;
        end;
    End;

Begin

      evaluation := 0.0;
      for i := 1 to high(sp) do
      Begin
           frequence_en_i := FFT_iToFreq(i);

           harmonique_hypothetique_numero := Round(frequence_en_i / freq);

           if harmonique_hypothetique_numero = 0 then
                 evaluation := evaluation - facteur_mauvaise_frequence_sous_harmonique_fondamentale * sp[i]
           else if BonneFrequence then
                   evaluation := evaluation + FacteurBonneFrequenceSelonHarmoniqueNumero(harmonique_hypothetique_numero) * sp[i]
           else
                 evaluation := evaluation - facteur_mauvaise_frequence * sp[i];



      End;


      result := evaluation;


End;


Function TesterFreq(var sp:TSpectrePuiss; freq: real): real;
    {la fonction teste si le spectre contient un son de la fréquence freq
       elle renvoit un genre de poids, d'autant plus grand que le son est
       suceptible de contenir la fréquence freq }
const maxnumharmo = 6;
      eci = 3;
var i,j, numharmo: integer;
    s, m, lm, maxavant: real;
    bonus : boolean;
    FFT_FreqBase: real;

        Function ChercherPic(i: integer): real;
        var m: real;
            j, j0: integer;
        Begin
             j0 := -100;
             m := -100;
             for j := i-eci to i+eci do
                  if ((sp[j] - sp[j+1]) >= 0{-sp[j]/10}) and
                     ((sp[j] - sp[j-1]) >= 0{-sp[j]/10}) then
                  Begin
                       if sp[j] > m then
                       Begin
                            //if (sp[j] >= sp[j+1]) and (sp[j] >= sp[j-1]) then
                                   m := sp[j]; //bonus
                            //else
                             //      m := sp[j] / 2;
                            j0 := j;


                       End;

                  End;
            if j0 = i then
                 result := sp[j0]
            else if j0 < 0 then
                result := sp[i] / 12
            else
            Begin
                result := sp[j0] / (2*(i - j0));
                //frmDetectionFreq.TracerPic(j0, $FF0000);
            End;



        End;


Begin
      s := 0;
      numharmo := 1;
      FFT_FreqBase := FFT_FreqBase_Get;
      i := round(numharmo * freq / FFT_FreqBase);



      maxavant := 0;
      for j := 0 to i-20 do
            if sp[j] > maxavant then
                  maxavant := sp[j];

      if maxavant > 1000 then
            s := -1;      //code erreur
      
      {si ne contient pas une valeur élevé en i (premier harmonique), c'est déjà pas la peine}
      if (maxavant < 1000) and (sp[i] > 16) and (i > eci) then
      Begin
            while (i + eci < FFT_MaxIFreq) and (numharmo <= maxnumharmo) do
            Begin
                //frmDetectionFreq.TracerPic(i, 255);
                m := ChercherPic(i);
                bonus := true;

                if numharmo > 3 then
                         if m > 2*lm then
                               bonus := false;

                lm := m;


                if bonus then
                     m := m * 2;

                if (i > 0) and (m > 64) then
                      s := s + m;

                inc(numharmo);
                i := round(numharmo * freq / FFT_FreqBase);

            End;
      End;

      result := s;

End;





end.
