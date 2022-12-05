{
TWebControl and TWebChromium classes

  ES: Clase para la manipulaci�n del contenido de un navegador TWebBrowser o TChromium
  EN: Class for management the contents of a browser TWebBrowser or TChromium

=========================================================================
History:

ver 1.2.0
  ES:
    error: TWebControl.SaveToJPGFile -> corregido error (GC: issue 17).
  EN:
    bug: TWebControl.SaveToJPGFile -> bug fixed (GC: issue 17).

ver 1.0.1
  ES:
    error: TWebControl -> m�todo WebFormFieldValue corregido (GC: issue 6).
    error: TWebChromium -> m�todo WebFormFieldValue corregido (GC: issue 6).
  EN:
    bug: TWebControl -> WebFormFieldValue method (GC: issue 6).
    bug: TWebChromium -> WebFormFieldValue method (GC: issue 6).

ver 0.1.9
  ES:
    nuevo: documentaci�n
    nuevo: se hace compatible con el navegador chromium y FireMonkey
  EN:
    new: documentation
    new: now compatible with chromium browser and FireMonkey
=========================================================================
IMPORTANTE PROGRAMADORES: Por favor, si tienes comentarios, mejoras,
  ampliaciones, errores y/o cualquier otro tipo de sugerencia, env�ame un correo a:
  gmlib@cadetill.com

IMPORTANT DEVELOPERS: please, if you have comments, improvements, enlargements,
  errors and/or any another type of suggestion, please send me a mail to:
  gmlib@cadetill.com
}
{*------------------------------------------------------------------------------
  The WebControlVCL unit includes the necessary classes to encapsulate the access to a browser with VCL framework.
  This browser can be a TWebBrowser or TChromium.
  You can de/activate this browsers into the gmlib.inc file.
  By default, only the TWebBrowser is active.

  @author Xavier Martinez (cadetill)
  @version 1.5.0
-------------------------------------------------------------------------------}
{=------------------------------------------------------------------------------
  La unit WebControlVCL incluye las clases necesarias para encapsular el acceso a un navegador mediante el framework de la VCL.
  Este navegador puede ser un TWebBrowser o TChromium.
  Puedes des/activar estos navegadores desde el archivo gmlib.inc.
  Por defecto, s�lo est� activo el TWebBrowser.

  @author Xavier Martinez (cadetill)
  @version 1.5.0
-------------------------------------------------------------------------------}
unit WebControlVCL;

{.$DEFINE WEBBROWSER}
{.$DEFINE CHROMIUM}
{$I ..\gmlib.inc}

interface

uses
  {$IFDEF WEBBROWSER}
  MSHTML, SHDocVw,
  {$ENDIF}

  {$IFDEF CHROMIUM}
  ceflib, cefvcl, Dialogs, GMFunctions,
  {$ENDIF}

  {$IFDEF DELPHIXE2}
  System.SysUtils,
  {$ELSE}
  SysUtils,
  {$ENDIF}

  WebControl;

type
  {*------------------------------------------------------------------------------
    TWebControl class is a specialization of TCustomWeb for a TWebBrowser browser.
    For that the compiler take into account this class, must be activated in the gmlib.inc file.
  -------------------------------------------------------------------------------}
  {=------------------------------------------------------------------------------
    La clase TWebControl es una especializaci�n de TCustomWeb para el navegador TWebBrowser.
    Para que el compilador tenga en cuenta esta clase debes activarla en el fichero gmlib.inc
  -------------------------------------------------------------------------------}
  {$IFDEF WEBBROWSER}
  TWebControl = class(TCustomWeb)
  protected
    {*------------------------------------------------------------------------------
      WebFormGet function return the form specified by FormNumber
      @param FormNumber index to form to return
      @return the form in IHTMLFormElement format
    -------------------------------------------------------------------------------}
    {=------------------------------------------------------------------------------
      La funci�n WebFormGet devuelve el formulario especificado por FormNumber
      @param FormNumber �ndice del formulario a devolver
      @return el formulario en formato IHTMLFormElement
    -------------------------------------------------------------------------------}
    function WebFormGet(const FormNumber: Integer): IHTMLFormElement;
    function WebFormFieldValue(const FormIdx: Integer; const FieldName: string): string; overload; override;
  public
    {*------------------------------------------------------------------------------
      Constructor of the class
      @param WebBrowser is the browser to manipulate
    -------------------------------------------------------------------------------}
    {=------------------------------------------------------------------------------
      Constructor de la clase
      @param WebBrowser es el navegador a manipular
    -------------------------------------------------------------------------------}
    constructor Create(WebBrowser: TWebBrowser); reintroduce; virtual;

    procedure WebFormNames; override;
    procedure WebFormFields(const FormIdx: Integer); overload; override;
    procedure WebFormSetFieldValue(const FormIdx: Integer; const FieldName, NewValue: string); overload; override;
    procedure WebFormSubmit(const FormIdx: Integer); overload; override;
    function WebHTMLCode: string; override;
    procedure WebPrintWithoutDialog; override;
    procedure WebPrintWithDialog; override;
    procedure WebPrintPageSetup; override;
    procedure WebPreview; override;
    procedure SaveToJPGFile(FileName: TFileName = ''); override;
    {*------------------------------------------------------------------------------
      Set a browser
      @param Browser browser to set
    -------------------------------------------------------------------------------}
    {=------------------------------------------------------------------------------
      Establece un navegador
      @param Browser navegador a establecer
    -------------------------------------------------------------------------------}
    procedure SetBrowser(Browser: TWebBrowser); reintroduce; virtual;
  end;
  {$ENDIF}

  {*------------------------------------------------------------------------------
    TWebChromium class is a specialization of TCustomWeb for a TChromium browser.
    For that the compiler take into account this class, must be activated in the file gmlib.inc
  -------------------------------------------------------------------------------}
  {=------------------------------------------------------------------------------
    La clase TWebChromium es una especializaci�n de TCustomWeb para el navegador TChromium.
    Para que el compilador tenga en cuenta esta clase debes activarla en el fichero gmlib.inc
  -------------------------------------------------------------------------------}
  {$IFDEF CHROMIUM}
  TWebChromium = class(TCustomWebChromium)
  private
    FCurrentFieldValue: string;
    FGetFormsFinished: Boolean;
    FGetFieldsFinished: Boolean;
    FGetFieldValueFinished: Boolean;
    FSetFieldValueFinished: Boolean;
  protected
    function WebFormFieldValue(const FormIdx: Integer; const FieldName: string): string; overload; override;
  public
    {*------------------------------------------------------------------------------
      Constructor of the class
      @param WebBrowser is the browser to manipulate
    -------------------------------------------------------------------------------}
    {=------------------------------------------------------------------------------
      Constructor de la clase
      @param WebBrowser es el navegador a manipular
    -------------------------------------------------------------------------------}
    constructor Create(WebBrowser: TChromium); reintroduce; virtual;

    procedure WebFormNames; override;
    procedure WebFormFields(const FormIdx: Integer); overload; override;
    procedure WebFormSetFieldValue(const FormIdx: Integer;
      const FieldName, NewValue: string); overload; override;
    procedure WebFormSubmit(const FormIdx: Integer); overload; override;
    function WebHTMLCode: string; override;
    procedure WebPrintWithoutDialog; override;
    procedure WebPrintWithDialog; override;
    procedure WebPrintPageSetup; override;
    procedure WebPreview; override;
    procedure SaveToJPGFile(FileName: TFileName = ''); override;
    {*------------------------------------------------------------------------------
      Set a browser
      @param Browser browser to set
    -------------------------------------------------------------------------------}
    {=------------------------------------------------------------------------------
      Establece un navegador
      @param Browser navegador a establecer
    -------------------------------------------------------------------------------}
    procedure SetBrowser(Browser: TChromium); reintroduce; virtual;
    property currentFieldValue: string read FCurrentFieldValue write FCurrentFieldValue;
    property getFormsFinished: Boolean read FGetFormsFinished write FGetFormsFinished;
    property getFieldsFinished: Boolean read FGetFieldsFinished write FGetFieldsFinished;
    property getFieldValueFinished: boolean read FGetFieldValueFinished write FGetFieldValueFinished;
    property setFieldValueFinished: boolean read FSetFieldValueFinished write FSetFieldValueFinished;
  end;

  ISourceContainer = interface(ICefStringVisitor)
    function Source: ustring;
  end;

  TSourceContainer = class(TCefStringVisitorOwn, ISourceContainer)
  private
    FSource: ustring;
    FLoaded: Boolean;
  protected
    procedure Visit(const str: ustring); override;
  public
    function Source: ustring;
    function Loaded: Boolean;
  end;

  TCustomRenderProcessHandler = class(TCefRenderProcessHandlerOwn)
  protected
    procedure OnWebKitInitialized; override;
  end;

  TFormsJSExtension = class
    class procedure GetFormsName(const data: string);
    class procedure GetFieldsName(const data: string);
    class procedure GetFieldValue(const data: string);
    class procedure SetFieldValue(const data: string);
  end;

  {$ENDIF}

implementation

uses
  {$IFDEF WEBBROWSER}
    {$IFDEF DELPHIXE2}
    Winapi.ActiveX, System.Types, Vcl.Graphics, Vcl.Forms, System.StrUtils,
    {$ELSE}
    ActiveX, Types, Graphics, Forms, StrUtils,
    {$ENDIF}
  {$ENDIF}

  {$IFDEF DELPHIXE2}
  Vcl.Imaging.jpeg, System.DateUtils;
  {$ELSE}
  jpeg, DateUtils;
  {$ENDIF}

{ TWebControl }

{$IFDEF WEBBROWSER}
constructor TWebControl.Create(WebBrowser: TWebBrowser);
begin
  inherited Create(WebBrowser);
end;

procedure TWebControl.SaveToJPGFile(FileName: TFileName);
var
  viewObject: IViewObject;
  r: TRect;
  {$IFDEF DELPHIXE2}
  bitmap: Vcl.Graphics.TBitmap;
  {$ELSE}
  bitmap: Graphics.TBitmap;
  {$ENDIF}
begin
  if not Assigned(FWebBrowser) then
    raise Exception.Create('WebBrowser not assigned');
  if not (FWebBrowser is TWebBrowser) then
    raise Exception.Create('The WebBrowser property is not a TWebBrowser.');

  TWebBrowser(FWebBrowser).Document.QueryInterface(IViewObject, viewObject);
  if Assigned(viewObject) then
  try
    {$IFDEF DELPHIXE2}
    bitmap := Vcl.Graphics.TBitmap.Create;
    {$ELSE}
    bitmap := Graphics.TBitmap.Create;
    {$ENDIF}
    try
      r := Rect(-2, -2, TWebBrowser(FWebBrowser).Width, TWebBrowser(FWebBrowser).Height);

      bitmap.Height := TWebBrowser(FWebBrowser).Height-4;
      bitmap.Width := TWebBrowser(FWebBrowser).Width-4;

      {$IFDEF DELPHIXE2}
      viewObject.Draw(DVASPECT_CONTENT, 1, nil, nil, Vcl.Forms.Application.Handle, bitmap.Canvas.Handle, @r, nil, nil, 0);
      {$ELSE}
      viewObject.Draw(DVASPECT_CONTENT, 1, nil, nil, Application.Handle, bitmap.Canvas.Handle, @r, nil, nil, 0);
      {$ENDIF}

      with TJPEGImage.Create do
      try
        Assign(bitmap);
        SaveToFile(FileName);
      finally
        Free;
      end;
    finally
      bitmap.Free;
    end;
  finally
    viewObject._Release;
  end;
end;

procedure TWebControl.SetBrowser(Browser: TWebBrowser);
begin
  inherited SetBrowser(Browser);
end;

procedure TWebControl.WebFormFields(const FormIdx: Integer);
var
  Form: IHTMLFormElement;
  Fld: IHTMLElement;
  FName: string;
  Idx: integer;
begin
  Fields.Clear;
  if not Assigned(FWebBrowser) then
    raise Exception.Create('WebBrowser not assigned');
  if not (FWebBrowser is TWebBrowser) then
    raise Exception.Create('The WebBrowser property is not a TWebBrowser.');
  if FForms.Count = 0 then
    raise Exception.Create('Property Forms not initialized or empty.');
  if (FormIdx < 0) or (FormIdx >= FForms.Count) then
    raise Exception.Create('Index out of bounds.');

  Form := WebFormGet(FormIdx);

  Fields.Clear;
  for idx := 0 to form.length - 1 do
  begin
    Fld := Form.Item(Idx, '') as IHTMLElement;

    if Fld = nil then Continue;
    FName := Fld.id;
    if Fld.tagName = 'INPUT' then FName := (Fld as IHTMLInputElement).name;
    if Fld.tagName = 'SELECT' then FName := (Fld as IHTMLSelectElement).name;
    if Fld.tagName = 'TEXTAREA' then FName := (Fld as IHTMLTextAreaElement).name;

    Fields.Add(FName) ;
  end;
end;

function TWebControl.WebFormFieldValue(const FormIdx: Integer;
  const FieldName: string): string;
var
  Form: IHTMLFormElement;
  Field: IHTMLElement;
begin
  Result := '';

  if not Assigned(FWebBrowser) then
    raise Exception.Create('WebBrowser not assigned');
  if not (FWebBrowser is TWebBrowser) then
    raise Exception.Create('The WebBrowser property is not a TWebBrowser.');

  Form := WebFormGet(FormIdx);
  if not Assigned(Form) then Exit;
  Field := Form.Item(FieldName,'') as IHTMLElement;
  if not Assigned(Field) then Exit;

  if Field.tagName = 'INPUT' then Result := (Field as IHTMLInputElement).value;
  if Field.tagName = 'SELECT' then Result := (Field as IHTMLSelectElement).value;
  if Field.tagName = 'TEXTAREA' then Result := (Field as IHTMLTextAreaElement).value;

  if Pos('&nbsp;', Result) > 0 then
    {$IFDEF DELPHI2005}
    Result := ReplaceText(Result, '&nbsp;', ' ');
    {$ELSE}
    Result := StringReplace(Result, '&nbsp;', ' ', [rfReplaceAll, rfIgnoreCase]);
    {$ENDIF}
end;

function TWebControl.WebFormGet(const FormNumber: Integer): IHTMLFormElement;
var
  Forms: IHTMLElementCollection;
begin
  Result := nil;
  if not Assigned(FWebBrowser) then
    raise Exception.Create('WebBrowser not assigned');
  if FWebBrowser is TWebBrowser then
  begin
    Forms := (TWebBrowser(FWebBrowser).Document as IHTMLDocument2).forms as IHTMLElementCollection;
    Result := Forms.Item(FormNumber, '') as IHTMLFormElement;
  end;
end;

procedure TWebControl.WebFormNames;
var
  Frms: IHTMLElementCollection;
  Frm: IHTMLFormElement;
  Idx: integer;
begin
  FForms.Clear;
  if not Assigned(FWebBrowser) then
    raise Exception.Create('WebBrowser not assigned');
  if not (FWebBrowser is TWebBrowser) then
    raise Exception.Create('The WebBrowser property is not a TWebBrowser.');

  Frms := (TWebBrowser(FWebBrowser).Document as IHTMLDocument2).forms as IHTMLElementCollection;
  for Idx := 0 to Frms.Length - 1 do
  begin
    Frm := Frms.Item(Idx,0) as IHTMLFormElement;
    FForms.Add(Frm.Name);
  end;
end;

procedure TWebControl.WebFormSetFieldValue(const FormIdx: Integer;
  const FieldName, NewValue: string);
var
  Form: IHTMLFormElement;
  Field: IHTMLElement;
begin
  inherited;

  if not Assigned(FWebBrowser) then
    raise Exception.Create('WebBrowser not assigned');
  if not (FWebBrowser is TWebBrowser) then
    raise Exception.Create('The WebBrowser property is not a TWebBrowser.');
  if (FormIdx < 0) or (FormIdx >= FForms.Count) then
    raise Exception.Create('Index out of bounds.');

  Form := WebFormGet(FormIdx);
  Field := Form.Item(FieldName, '') as IHTMLElement;
  if Field = nil then Exit;

  if Field.tagName = 'INPUT' then (Field as IHTMLInputElement).value := NewValue;
  if Field.tagName = 'SELECT' then (Field as IHTMLSelectElement).value := NewValue;
  if Field.tagName = 'TEXTAREA' then (Field as IHTMLTextAreaElement).value := NewValue;
end;

procedure TWebControl.WebFormSubmit(const FormIdx: Integer);
var
  Form: IHTMLFormElement;
begin
  inherited;

  if not Assigned(FWebBrowser) then
    raise Exception.Create('WebBrowser not assigned');
  if not (FWebBrowser is TWebBrowser) then
    raise Exception.Create('The WebBrowser property is not a TWebBrowser.');

  Form := WebFormGet(FormIdx);

  Form.submit;
end;

function TWebControl.WebHTMLCode: string;
begin
  if not Assigned(FWebBrowser) then
    raise Exception.Create('WebBrowser not assigned');
  if not (FWebBrowser is TWebBrowser) then
    raise Exception.Create('The WebBrowser property is not a TWebBrowser.');

  Result := IHTMLDocument2(TWebBrowser(FWebBrowser).Document).body.innerHTML;
end;

procedure TWebControl.WebPreview;
var
  vIn, vOut: OleVariant;
begin
  if not Assigned(FWebBrowser) then
    raise Exception.Create('WebBrowser not assigned');
  if not (FWebBrowser is TWebBrowser) then
    raise Exception.Create('The WebBrowser property is not a TWebBrowser.');

  TWebBrowser(FWebBrowser).ControlInterface.ExecWB(OLECMDID_PRINTPREVIEW, OLECMDEXECOPT_DONTPROMPTUSER, vIn, vOut) ;
end;

procedure TWebControl.WebPrintPageSetup;
var
  vIn, vOut: OleVariant;
begin
  if not Assigned(FWebBrowser) then
    raise Exception.Create('WebBrowser not assigned');
  if not (FWebBrowser is TWebBrowser) then
    raise Exception.Create('The WebBrowser property is not a TWebBrowser.');

  TWebBrowser(FWebBrowser).ControlInterface.ExecWB(OLECMDID_PAGESETUP, OLECMDEXECOPT_PROMPTUSER, vIn, vOut) ;
end;

procedure TWebControl.WebPrintWithDialog;
var
  vIn, vOut: OleVariant;
begin
  if not Assigned(FWebBrowser) then
    raise Exception.Create('WebBrowser not assigned');
  if not (FWebBrowser is TWebBrowser) then
    raise Exception.Create('The WebBrowser property is not a TWebBrowser.');

  TWebBrowser(FWebBrowser).ControlInterface.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_PROMPTUSER, vIn, vOut) ;
end;

procedure TWebControl.WebPrintWithoutDialog;
var
  vIn, vOut: OleVariant;
begin
  if not Assigned(FWebBrowser) then
    raise Exception.Create('WebBrowser not assigned');
  if not (FWebBrowser is TWebBrowser) then
    raise Exception.Create('The WebBrowser property is not a TWebBrowser.');

  TWebBrowser(FWebBrowser).ControlInterface.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_DONTPROMPTUSER, vIn, vOut) ;
end;
{$ENDIF}

{ TWebChromium }

{$IFDEF CHROMIUM}
constructor TWebChromium.Create(WebBrowser: TChromium);
begin
  inherited Create(WebBrowser);
  FCurrentFieldValue := '';
  FGetFormsFinished := false;
  FGetFieldsFinished := false;
  FGetFieldValueFinished := false;
  FSetFieldValueFinished := false;
end;

procedure TWebChromium.SaveToJPGFile(FileName: TFileName);
var
   bmp: Vcl.Graphics.TBitmap;
begin
  if not Assigned(FWebBrowser) then
    raise Exception.Create('WebBrowser not assigned');
  if not (FWebBrowser is TChromium) then
    raise Exception.Create('The WebBrowser property is not a TChromium.');

  bmp := Vcl.Graphics.TBitMap.Create;
  try
    //cefvcl.CefGetBitmap(TChromium(FWebBrowser).Browser, PET_VIEW, bmp);
    with TJPEGImage.Create do
    try
      Assign(bmp);
      SaveToFile(FileName);
    finally
      Free;
    end;
  finally
    FreeAndNil(bmp);
  end;
end;

procedure TWebChromium.SetBrowser(Browser: TChromium);
begin
  FWebBrowser := Browser;
end;

procedure TWebChromium.WebFormFields(const FormIdx: Integer);
var
  FormName: string;
  EndTime: TDateTime;
begin

  Fields.Clear;
  FGetFieldsFinished := false;

  if not Assigned(FWebBrowser) then
    raise Exception.Create('WebBrowser not assigned');
  if not (FWebBrowser is TChromium) then
    raise Exception.Create('The WebBrowser property is not a TChromium.');
  if FForms.Count = 0 then
    raise Exception.Create('Property Forms not initialized or empty.');
  if (FormIdx < 0) or (FormIdx >= FForms.Count) then
    raise Exception.Create('Index out of bounds.');

  FormName := FForms[FormIdx];

  TChromium(FWebBrowser).Browser.MainFrame.ExecuteJavaScript(
    'gmGetFieldsName('''+ FormName +''');',
    'about:blank',
    0
  );

  EndTime := IncSecond(Time, 4);

  repeat Sleep(1); Application.ProcessMessages; until ((Time > EndTime) or FGetFieldsFinished);

end;

function TWebChromium.WebFormFieldValue(const FormIdx: Integer;
  const FieldName: string): string;
var
  FormName: string;
  EndTime: TDateTime;
begin
  inherited;

  FCurrentFieldValue := '';
  FGetFieldValueFinished := false;

  if not Assigned(FWebBrowser) then
    raise Exception.Create('WebBrowser not assigned');
  if not (FWebBrowser is TChromium) then
    raise Exception.Create('The WebBrowser property is not a TChromium.');
  if FForms.Count = 0 then
    raise Exception.Create('Property Forms not initialized or empty.');
  if (FormIdx < 0) or (FormIdx >= FForms.Count) then
    raise Exception.Create('Index out of bounds.');

  FormName := FForms[FormIdx];

  TChromium(FWebBrowser).Browser.MainFrame.ExecuteJavaScript(
    'gmGetFieldValue('''+ FormName +''', '''+ FieldName +''');',
    'about:blank',
    0
  );

  EndTime := IncSecond(Time, 4);

  repeat TGMGenFunc.ProcessMessages; until ((Time > EndTime) or FGetFieldValueFinished);

  Result := FCurrentFieldValue;

  if Pos('&nbsp;', Result) > 0 then
    {$IFDEF DELPHI2005}
    Result := ReplaceText(Result, '&nbsp;', ' ');
    {$ELSE}
    Result := StringReplace(Result, '&nbsp;', ' ', [rfReplaceAll, rfIgnoreCase]);
    {$ENDIF}
end;

procedure TWebChromium.WebFormNames;
var
  EndTime: TTime;
begin
  if FGetFormsFinished then exit;

  FForms.Clear;
  FGetFormsFinished := false;

  if not Assigned(FWebBrowser) then
    raise Exception.Create('WebBrowser not assigned');
  if not (FWebBrowser is TChromium) then
    raise Exception.Create('The WebBrowser property is not a TChromium.');

  TChromium(FWebBrowser).Browser.MainFrame.ExecuteJavaScript(
    'gmGetFormsName();',
    'about:blank',
    0
  );

  EndTime := IncSecond(Time, 4);

  repeat Sleep(1); Application.ProcessMessages; until (Time > EndTime);
  if (Time > EndTime) and (not FGetFormsFinished) then
    raise Exception.Create('Get Forms Name time out');
end;

procedure TWebChromium.WebFormSetFieldValue(const FormIdx: Integer;
  const FieldName, NewValue: string);
var
  FormName: string;
  EndTime: TDateTime;
begin
  inherited;

  FCurrentFieldValue := '';
  FSetFieldValueFinished := false;

  if not Assigned(FWebBrowser) then
    raise Exception.Create('WebBrowser not assigned');
  if not (FWebBrowser is TChromium) then
    raise Exception.Create('The WebBrowser property is not a TChromium.');
  if FForms.Count = 0 then
    raise Exception.Create('Property Forms not initialized or empty.');
  if (FormIdx < 0) or (FormIdx >= FForms.Count) then
    raise Exception.Create('Index out of bounds.');

  FormName := FForms[FormIdx];

  TChromium(FWebBrowser).Browser.MainFrame.ExecuteJavaScript(
    'gmSetFieldValue('''+ FormName +''', '''+ FieldName +''', '''+ NewValue +''');',
    'about:blank',
    0
  );

  EndTime := IncSecond(Time, 4);

  repeat Sleep(1); TGMGenFunc.ProcessMessages; until ((Time > EndTime) or FSetFieldValueFinished);

end;

procedure TWebChromium.WebFormSubmit(const FormIdx: Integer);
var
  FormName: string;
begin
  inherited;

  if not Assigned(FWebBrowser) then
    raise Exception.Create('WebBrowser not assigned');
  if not (FWebBrowser is TChromium) then
    raise Exception.Create('The WebBrowser property is not a TChromium.');
  if FForms.Count = 0 then
    raise Exception.Create('Property Forms not initialized or empty.');
  if (FormIdx < 0) or (FormIdx >= FForms.Count) then
    raise Exception.Create('Index out of bounds.');

  FormName := FForms[FormIdx];

  if TChromium(FWebBrowser).Browser <> nil then
    TChromium(FWebBrowser).Browser.MainFrame.ExecuteJavaScript(
      'document.forms["' + FormName + '"].submit();', 'about:blank', 0);
end;

function TWebChromium.WebHTMLCode: string;
var
  SourceContainer: TSourceContainer;
  EndTime: TDateTime;
begin
  Result := '';
  if not Assigned(FWebBrowser) then
    raise Exception.Create('WebBrowser not assigned');
  if not (FWebBrowser is TChromium) then
    raise Exception.Create('The WebBrowser property is not a TChromium.');

  if TChromium(FWebBrowser).Browser = nil then Exit;

  SourceContainer := TSourceContainer.Create;
  TChromium(FWebBrowser).Browser.MainFrame.GetSource(SourceContainer);

  EndTime := IncSecond(Time, 10);

  repeat Sleep(1); Application.ProcessMessages; until SourceContainer.Loaded or (Time > EndTime);
  if Time > EndTime then
    raise Exception.Create('Time out');

  Result := SourceContainer.Source;
end;

procedure TWebChromium.WebPreview;
begin
  raise Exception.Create('This method is not implemented for this class. Call WebPrintWithDialog in his stead.');
end;

procedure TWebChromium.WebPrintPageSetup;
begin
  raise Exception.Create('This method is not implemented for this class. Call WebPrintWithDialog in his stead.');
end;

procedure TWebChromium.WebPrintWithDialog;
begin
  if not Assigned(FWebBrowser) then
    raise Exception.Create('WebBrowser not assigned');
  if not (FWebBrowser is TChromium) then
    raise Exception.Create('The WebBrowser property is not a TChromium.');

  if TChromium(FWebBrowser).Browser <> nil then
    ICefBrowserHost(TChromium(FWebBrowser).Browser.MainFrame).Print;
end;

procedure TWebChromium.WebPrintWithoutDialog;
begin
  raise Exception.Create('This method is not implemented for this class. Call WebPrintWithDialog in his stead.');
end;

{ TSourceContainer }

function TSourceContainer.Source: ustring;
begin
  Result := FSource;
end;

function TSourceContainer.Loaded: Boolean;
begin
  Result := FLoaded;
end;

procedure TSourceContainer.Visit(const str: ustring);
begin
  FSource := str;
  FLoaded := true;
end;

{ TCustomRenderProcessHandler }

procedure TCustomRenderProcessHandler.OnWebKitInitialized;
begin
  TCefRTTIExtension.Register('gmlibd', TFormsJSExtension);
end;

{ TFormsJSExtension }

class procedure TFormsJSExtension.GetFormsName(const data: string);
var
  msg: ICefProcessMessage;
begin
  msg := TCefProcessMessageRef.New('GetFormsName');
  msg.ArgumentList.SetString(0, data);
  TCefv8ContextRef.Current.Browser.SendProcessMessage(PID_BROWSER, msg);
end;

class procedure TFormsJSExtension.GetFieldsName(const data: string);
var
  msg: ICefProcessMessage;
begin
  msg := TCefProcessMessageRef.New('GetFieldsName');
  msg.ArgumentList.SetString(0, data);
  TCefv8ContextRef.Current.Browser.SendProcessMessage(PID_BROWSER, msg);
end;

class procedure TFormsJSExtension.GetFieldValue(const data: string);
var
  msg: ICefProcessMessage;
begin
  msg := TCefProcessMessageRef.New('GetFieldValue');
  msg.ArgumentList.SetString(0, data);
  TCefv8ContextRef.Current.Browser.SendProcessMessage(PID_BROWSER, msg);
end;

class procedure TFormsJSExtension.SetFieldValue(const data: string);
var
  msg: ICefProcessMessage;
begin
  msg := TCefProcessMessageRef.New('SetFieldValue');
  msg.ArgumentList.SetString(0, data);
  TCefv8ContextRef.Current.Browser.SendProcessMessage(PID_BROWSER, msg);
end;

initialization
  CefRenderProcessHandler := TCustomRenderProcessHandler.Create;
  CefBrowserProcessHandler := TCefBrowserProcessHandlerOwn.Create;

{$ENDIF}

end.
