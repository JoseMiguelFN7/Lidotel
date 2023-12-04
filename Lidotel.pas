program Lidotel;
{$codepage UTF8} //Permite usar acentos y ñ en consola.
uses crt;
type
    habitacion = record
        nombre: string;
        precio: integer;
    end;
    cliente = record
        nombre: string;
        apellido: string;
        ci: string;
        email: string;
        telefono: string;
        diasEstadia: integer;
        tReservacion: string;
        tHabitacion: habitacion;
    end;
    nino = record
        nombre: string;
        apellido: string;
        edad: integer;
        diasEstadia: integer;
        tReservacion: string;
        tHabitacion: habitacion;
    end;

var
i: integer;
op: char;

clientesEnSesion: array of cliente;
ninosEnSesion: array of nino;

const
    tReservaciones: array[1..3] of string = ('Individual', 'Acompanado', 'Grupo/Familia');
    tipoHab: array [1..4] of habitacion = (
       (nombre: 'Sencilla.'; precio: 60),
       (nombre: 'Doble.'; precio: 120),
       (nombre: 'Family Room.'; precio: 200),
       (nombre: 'Suite.'; precio: 300)
    );

function seleccionarTHab(): habitacion;
var
opp1, opp2: char;
begin
    repeat
        writeln('Por favor, indique el tipo de habitacion:');
        writeln('1. Sencilla.');
        writeln('2. Doble.');
        writeln('3. Family Room.');
        writeln('4. Suite.');
        opp1:=readkey;
        case (opp1) of
            '1': begin
                //Mostar descripcion de Sencilla
            end;
            '2': begin
                //Mostar descripcion de Doble
            end;
            '3': begin
                //Mostar descripcion de Family Room
            end;
            '4': begin
                //Mostar descripcion de Suite
            end
            else begin
                writeln('Opcion no valida.');
            end;
            if (opp1 in ['1','2','3','4']) then
            begin
                //mostrar info entipoHab[ord(pp1)];
                repeat
                    writeln('Desea confirmar su seleccion? (S/N)');
                    opp2:=readkey;
                    case (opp2) of
                        's', 'S': begin
                            writeln('Habitacion confirmada exitosamente.');
                            seleccionarTHab:=tipoHab[ord(opp1)];
                        end;
                        'n', 'N': begin
                            writeln('Seleccion cancelada.');
                        end
                        else begin
                            writeln('Opcion no valida.');
                        end;
                    end;
                until (opp2 in ['s', 'S', 'n', 'N']);
            end;
        end;
    until (opp1 in ['1','2','3','4']) and (opp2 in ['s', 'S']);
end;

procedure nuevaReservacion();
var
opp: char;
nAdultos, nNinos, dEstadia, age: integer;
habSelec: habitacion;
nom, ape, cedula, correo, tel: string;

begin
    repeat
        writeln('Por favor, indique el tipo de reservacion:');
        writeln('1. Individual.');
        writeln('2. Acompañado.');
        writeln('3. Grupo/Familia.');
        opp:=readkey;
        case(opp) of
            '1': begin
                setLength(clientesEnSesion, 1);
            end;
            '2': begin
                setLength(clientesEnSesion, 2);
                
            end;
            '3': begin
                write('Indique la cantidad de adultos:');
                readln(nAdultos);
                write('Indique la cantidad de niños:');
                readln(nNinos);
                setLength(clientesEnSesion, nAdultos);
                setLength(ninosEnSesion, nNinos);
            end
            else begin
              writeln('Opcion no valida.');
            end;
        end;
        if(opp in ['1', '2', '3']) then
        begin
            habSelec:=seleccionarTHab();
            write('Ingrese los dias de estadia');
            readln(dEstadia);
            for i:=0 to length(clientesEnSesion)-1 do
            begin
                with clientesEnSesion[i] do
                begin
                    Reservacion:=tReservaciones[ord(opp)];
                    tHabitacion:=habSelec;
                    diasEstadia:=dEstadia;
                end;
            end;
            for i:=0 to length(ninosEnSesion)-1 do
            begin
                with ninosEnSesion[i] do
                begin
                    Reservacion:=tReservaciones[ord(opp)];
                    tHabitacion:=habSelec;
                    diasEstadia:=dEstadia;
                end;
            end;
        end;
    until (opp in ['1', '2', '3']);
    for i:=0 to length(clientesEnSesion)-1 do
    begin
        write('Ingrese el nombre del adulto ', i+1, ':');
        readln(nom);
        write('Ingrese el apellido del adulto ', i+1, ':');
        readln(ape);
        write('Ingrese la cedula del adulto ', i+1, ':');
        readln(cedula);
        write('Ingrese el correo del adulto ', i+1, ':');
        readln(correo);
        write('Ingrese el telefono del adulto ', i+1, ':');
        readln(tel);
        with clientesEnSesion[i] do
        begin
            nombre:=nom;
            apellido:=ape;
            ci:=cedula;
            email:=correo;
            telefono:=tel;
        end;
    end;
    for i:=0 to length(clientesEnSesion)-1 do
    begin
        write('Ingrese el nombre del niño ', i+1, ':');
        readln(nom);
        write('Ingrese el apellido del niño ', i+1, ':');
        readln(ape);
        write('Ingrese la edad del niño ', i+1, ':');
        readln(age);
        with clientesEnSesion[i] do
        begin
            nombre:=nom;
            apellido:=ape;
            edad:=age;
        end;
    end;
end;

begin
    clrscr;
    writeln('Bienvenido al sistema del Hotel Lidotel Boutique Margarita!');
    writeln('Presione cualquier tecla para continuar...');
    readkey;
    repeat
        writeln('Por favor indique la operacion a realizar:');
        writeln('1. Nuevo cliente.');
        writeln('2. Buscar reservacion.');
        writeln('3. Modificar reservacion.');
        writeln('4. Salir.');
        op:=readkey;
        nuevoRegistro();
        case(op) of
            '1': begin
                nuevaReservacion();
            end;
            '2': begin
                readkey;
            end;
            '3': begin
                readkey;
            end;
            '4': begin
                writeln('Gracias por usar el sistema, vuelva pronto.');
            end
            else begin
                writeln('Opcion no valida.');
            end;
        end;
    until op='4';
end.