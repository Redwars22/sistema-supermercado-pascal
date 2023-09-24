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
    CalculateExchange: TButton;
    AddToCheckout: TButton;
    ExchangeValue: TFloatSpinEdit;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label3: TLabel;
    ProductCode: TEdit;
    TotalPrice: TLabel;
    NotaFiscal: TListBox;
    ProductQuantity: TSpinEdit;
    Exchange: TLabel;
    procedure AddToCheckoutClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CalculateExchangeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GetProductInfoFromID(Code: String);
  private

  public

  end;

var
  Form1: TForm1;
  Code: String;
  Quantity: Integer;
  Total: Double;
  Price: Double;
  ProductLabel: String;
  NotaFiscalString: String;
  ExchangeVal: Double;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.GetProductInfoFromID(Code: String);
begin
    case Code of
         '123456':
            begin
                 ProductLabel := 'ÁGUA MINERAL LA FONTE';
                 Price := 1.00;
            end;
         '987654':
            begin
                 ProductLabel := 'SABONETE FRANCIS';
                 Price := 3.15;
            end;
         '999876':
            begin
                 ProductLabel := 'DETERGENTE YPÊ';
                 Price := 4.79;
            end;
         '133345':
            begin
                 ProductLabel := 'SABÃO EM PÓ YPÊ';
                 Price := 6.47;
            end;
         '876542':
            begin
                 ProductLabel := 'LEITE LONGA VIDA';
                 Price := 4.99;
            end;
         '132331':
            begin
                 ProductLabel := 'REFRIGERANTE COCA COLA';
                 Price := 6.87;
            end;
         '919191':
            begin
                 ProductLabel := 'LEITE TERRA VIVA';
                 Price := 4.22;
            end;
         '049876':
            begin
                 ProductLabel := 'SALGADINHO FANDANGOS QUEIJO';
                 Price := 2.49;
            end;
         '131925':
            begin
                 ProductLabel := 'CAMISINHA DESFRUTE O PRAZER';
                 Price := 3.99;
            end;
         else
              begin
                   ProductLabel := 'NOT_FOUND';
              end;
    end;
end;

procedure TForm1.AddToCheckoutClick(Sender: TObject);
begin
    Code := ProductCode.Text;
    Quantity := ProductQuantity.Value;

    GetProductInfoFromID(Code);

    if ProductLabel = 'NOT_FOUND' then
       begin
            ProductCode.Text := '';
            ProductQuantity.Value := 1;
            Exit;
       end;
    //Price := 9.99;

    Total := Total + (Price * Quantity);

    TotalPrice.Caption := Format('TOTAL A PAGAR: R$ %.2f', [Total]);

    ProductCode.Text := '';
    ProductQuantity.Value := 1;

    //Adicionar na nota fiscal
    NotaFiscalString := Format('%s - QT. %d - UNID. R$ %.2f', [ProductLabel, Quantity, Total]);
    NotaFiscal.Items.Add(NotaFiscalString);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    Total := 0.0;
    ExchangeVal := 0.0;
    NotaFiscal.Items.Clear;

    TotalPrice.Caption := Format('TOTAL A PAGAR: R$ %.2f', [Total]);
    Exchange.Caption := Format('TROCO: R$ %.2f', [ExchangeVal]);
end;

procedure TForm1.CalculateExchangeClick(Sender: TObject);
begin
  ExchangeVal := ExchangeValue.Value - Total;

  Exchange.Caption := Format('TROCO: R$ %.2f', [ExchangeVal]);
end;

end.

