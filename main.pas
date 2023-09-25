unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin,
  ExtCtrls;

type
  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    EndSession: TButton;
    CalculateExchange: TButton;
    AddToCheckout: TButton;
    ExchangeValue: TFloatSpinEdit;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    UserLabel: TLabel;
    Label3: TLabel;
    ProductCode: TEdit;
    TotalPrice: TLabel;
    NotaFiscal: TListBox;
    ProductQuantity: TSpinEdit;
    Exchange: TLabel;
    procedure AddToCheckoutClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CalculateExchangeClick(Sender: TObject);
    procedure EndSessionClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GetProductInfoFromID(Code: String);
    procedure Image1Click(Sender: TObject);
    procedure CleanUp();
    procedure UpdateTotalPrice();
    procedure UpdateNotaFiscal();
    function AskForAdminPassword(): Boolean;
  private

  public

  end;

type
  TProduct = object
      Code: String;
      Quantity: Integer;
      Price: Double;
      ProductLabel: String;
      NotaFiscalString: String;
      function CalculatePrice(ATotal: Double; APrice: Double; AQuantity: Integer): Double;
  end;

var
  Form1: TForm1;
  Product: TProduct;
  TotalValue: Double;
  ExchangeVal: Double;
  DialogResult: Integer;
  AdminPassword: String;
  UserName: String;

const
     Password = 'admin123';

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
   while AdminPassword <> Password do
         begin
              if AskForAdminPassword() then
                 begin
                      if AdminPassword = Password then
                         begin
                              break;
                         end;

                      Application.MessageBox('A senha informada está incorreta. Contate o administrador para obtê-la.', 'Senha incorreta', 0);
                      continue;
                 end;

              halt(0);
         end;

   if Password = 'admin123' then
      begin
           UserName := 'JÉSSICA ALVES DOS SANTOS';
           UserLabel.Caption := Format('OPERADOR DO CAIXA: %s - SESSÃO ABERTA ÀS %s', [UserName, DateTimeToStr(Now)]);
      end;
end;

procedure TForm1.GetProductInfoFromID(Code: String);
begin
    case Code of
         '123456':
            begin
                 Product.ProductLabel := 'ÁGUA MINERAL LA FONTE';
                 Product.Price := 1.00;
            end;
         '987654':
            begin
                 Product.ProductLabel := 'SABONETE FRANCIS';
                 Product.Price := 3.15;
            end;
         '999876':
            begin
                 Product.ProductLabel := 'DETERGENTE YPÊ';
                 Product.Price := 4.79;
            end;
         '133345':
            begin
                 Product.ProductLabel := 'SABÃO EM PÓ YPÊ';
                 Product.Price := 6.47;
            end;
         '876542':
            begin
                 Product.ProductLabel := 'LEITE LONGA VIDA';
                 Product.Price := 4.99;
            end;
         '132331':
            begin
                 Product.ProductLabel := 'REFRIGERANTE COCA COLA';
                 Product.Price := 6.87;
            end;
         '919191':
            begin
                 Product.ProductLabel := 'LEITE TERRA VIVA';
                 Product.Price := 4.22;
            end;
         '049876':
            begin
                 Product.ProductLabel := 'SALGADINHO FANDANGOS QUEIJO';
                 Product.Price := 2.49;
            end;
         '131925':
            begin
                 Product.ProductLabel := 'CAMISINHA DESFRUTE O PRAZER';
                 Product.Price := 3.99;
            end;
         else
              begin
                   Product.ProductLabel := 'NOT_FOUND';
              end;
    end;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin

end;

procedure TForm1.CleanUp();
begin
    ProductCode.Text := '';
    ProductQuantity.Value := 1;
end;

procedure TForm1.UpdateTotalPrice();
begin
   TotalPrice.Caption := Format('TOTAL A PAGAR: R$ %.2f', [TotalValue]);
end;

procedure TForm1.UpdateNotaFiscal();
begin
   Product.NotaFiscalString := Format('%s - QT. %d - UNID. R$ %.2f', [Product.ProductLabel, Product.Quantity, Product.Price]);
   NotaFiscal.Items.Add(Product.NotaFiscalString);
end;

procedure TForm1.AddToCheckoutClick(Sender: TObject);
begin
    Product.Code := ProductCode.Text;
    Product.Quantity := ProductQuantity.Value;

    GetProductInfoFromID(Product.Code);

    if Product.ProductLabel = 'NOT_FOUND' then
       begin
            CleanUP();
            Application.MessageBox('O produto não pôde ser encontrado. Certifique-se de que seu código esteja correto.','Produto não cadastrado',0);
            Exit;
       end;

    TotalValue := Product.CalculatePrice(TotalValue, Product.Price, Product.Quantity);

    UpdateTotalPrice();

    ProductCode.Text := '';
    ProductQuantity.Value := 1;

    //Adicionar na nota fiscal
    UpdateNotaFiscal();
end;

//Pedir a senha do admin
function TForm1.AskForAdminPassword(): Boolean;
begin
    Exit(InputQuery('Insira a senha do administrador', 'Senha do Administrador:', AdminPassword) );
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    DialogResult := MessageDlg('Tem certeza de que deseja cancelar a compra?', mtConfirmation, mbYesNo, 0);

    if DialogResult = mrYes then
       begin
            if AskForAdminPassword() then
               begin
                    if AdminPassword = Password then
                       begin
                         TotalValue := 0.0;
                         ExchangeVal := 0.0;
                         NotaFiscal.Items.Clear;

                         UpdateTotalPrice();
                         Exchange.Caption := Format('TROCO: R$ %.2f', [ExchangeVal]);
                         Exit;
                       end;

                    Application.MessageBox('A senha informada está incorreta. Contate o administrador para obtê-la.', 'Senha incorreta', 0)
               end;
       end;
end;

procedure TForm1.CalculateExchangeClick(Sender: TObject);
begin
  ExchangeVal := ExchangeValue.Value - TotalValue;

  Exchange.Caption := Format('TROCO: R$ %.2f', [ExchangeVal]);
end;

procedure TForm1.EndSessionClick(Sender: TObject);
begin
    if AskForAdminPassword() then
       begin
            if AdminPassword = Password then
               begin
                    Application.MessageBox('A sessão foi encerrada com sucesso.', 'Senha incorreta', 0);
                    halt(0);
               end;

            Application.MessageBox('A senha informada está incorreta. Contate o administrador para obtê-la.', 'Senha incorreta', 0);
       end;
end;

{ TProduct }
function TProduct.CalculatePrice(ATotal: Double; APrice: Double; AQuantity: Integer): Double;
begin
   Exit(ATotal + (APrice * AQuantity));
end;

end.

