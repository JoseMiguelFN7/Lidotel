program Lidotel;
{$codepage UTF8} //Permite usar acentos y ñ en consola.

{Integrantes del grupo:
Jose Ferreira V28315655
Adriano Robati V}

uses crt, sysutils;
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
    end;
    nino = record
        nombre: string;
        apellido: string;
        edad: integer;
    end;
    reservacion = record
        id: integer;
        tReservacion: string;
        tHabitacion: habitacion;
        diasEstadia: integer;
        clientesEnSesion: array of cliente;
        ninosEnSesion: array of nino;
        precioTotal: real;
    end;

const
    tReservaciones: array[1..3] of RawByteString = ('Individual', 'Acompañado', 'Grupo-Familia');
    tipoHab: array [1..4] of habitacion = (
       (nombre: 'Sencilla'; precio: 60),
       (nombre: 'Doble'; precio: 120),
       (nombre: 'Family Room'; precio: 200),
       (nombre: 'Suite'; precio: 300));

var
i, IDSelInt: integer;
op1, op2: string;
archivoIndividual, archivoAcompanado, archivoGF, archivoSel: Text;
reservacionActual: reservacion;
tResSel, IDSel: string;
a: reservacion;

function determinarId(var archivo: Text; nombreArchivo: string): integer;
var
linea: string;
idmax: integer;
begin
    idmax:=0;
    if(FileExists(nombreArchivo)) then
    begin
        reset(archivo);
        while not (eof(archivo)) do
        begin
            readLn(archivo, linea);
            if(Copy(linea, 1, 2)='ID') then
            begin
                if (StrToInt(Copy(linea, 5, length(linea)))>idmax) then
                begin
                    idmax:=StrToInt(Copy(linea, 5, length(linea)));
                end;
            end;
        end;
    end;
    determinarId:=idmax+1;
end;

function idMasAlto(var archivo: Text; nombreArchivo: string): integer;
begin
    idMasAlto:=determinarId(archivo, nombreArchivo)-1;
end;

procedure almacenarEnArchivo(var archivo: Text; nombreArchivo: string; res: reservacion);
begin
    if(FileExists(nombreArchivo)) then
    begin
        append(archivo);
    end
    else begin
        assign(archivo, nombreArchivo);
        rewrite(archivo);
    end;
    writeLn(archivo, 'Datos de la reserva:');
    writeLn(archivo, 'ID: ', res.id);
    writeLn(archivo, 'Tipo de reserva: ', res.tReservacion);
    writeLn(archivo, 'Tipo de habitacion: ', res.tHabitacion.nombre);
    writeLn(archivo, 'Dias de estadia: ', res.diasEstadia);
    writeLn(archivo, 'Precio total: ', (res.precioTotal):0:2, '$');
    writeLn(archivo, 'Informacion de clientes:');
    for i:=0 to length(res.clientesEnSesion)-1 do
    begin
        writeLn(archivo, 'Adulto ', i+1, ':');
        with res.clientesEnSesion[i] do
        begin
            writeLn(archivo, '   Nombre: ', nombre);
            writeLn(archivo, '   Apellido: ', apellido);
            writeLn(archivo, '   Cedula: ', ci);
            writeLn(archivo, '   E-mail: ', email);
            writeLn(archivo, '   Telefono: ', telefono);
            
        end;
    end;
    for i:=0 to length(res.ninosEnSesion)-1 do
    begin
        writeLn(archivo, 'Niño ', i+1, ':');
        with res.ninosEnSesion[i] do
        begin
            writeLn(archivo, '   Nombre: ', nombre);
            writeLn(archivo, '   Apellido: ', apellido);
            writeLn(archivo, '   Edad: ', edad);
        end;
    end;
    writeLn(archivo, '----------------------------------------------------------------------------------');
    close(archivo);
end;

function seleccionarTHab(): habitacion;
var
opp1, opp2: string;
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
        end;
        if (opp1[1] in ['1','2','3','4']) then
        begin
            //mostrar info en tipoHab[StrToInt(pp1)];
            repeat
                writeln('Desea confirmar su seleccion? (S/N)');
                opp2:=readkey;
                case (opp2) of
                    's', 'S': begin
                        writeln('Habitacion confirmada exitosamente.');
                        seleccionarTHab:=tipoHab[StrToInt(opp1)];
                    end;
                    'n', 'N': begin
                        writeln('Seleccion cancelada.');
                    end
                    else begin
                        writeln('Opcion no valida.');
                    end;
                end;
            until (opp2[1] in ['s', 'S', 'n', 'N']);
        end;
    until (opp1[1] in ['1','2','3','4']) and (opp2[1] in ['s', 'S']);
end;

procedure nuevaReservacion(var res: reservacion);
var
opp: string;
nAdultos, nNinos, dEstadia, age: integer;
nom, ape, cedula, correo, tel: string;

begin
    repeat
        writeln('Por favor, indique el tipo de reservacion:');
        writeln('1. Individual.');
        writeln('2. Acompañado.');
        writeln('3. Grupo-Familia.');
        opp:=readkey;
        case(opp) of
            '1': begin
                setLength(res.clientesEnSesion, 1);
                res.id:=determinarId(archivoIndividual, 'Reservas Individual.txt');
            end;
            '2': begin
                setLength(res.clientesEnSesion, 2);
                res.id:=determinarId(archivoAcompanado, 'Reservas Acompañado.txt');
            end;
            '3': begin
                write('Indique la cantidad de adultos:');
                readln(nAdultos);
                write('Indique la cantidad de niños:');
                readln(nNinos);
                setLength(res.clientesEnSesion, nAdultos);
                setLength(res.ninosEnSesion, nNinos);
                res.id:=determinarId(archivoGF, 'Reservas Grupo-Familia.txt');
            end
            else begin
              writeln('Opcion no valida.');
            end;
        end;
        if(opp[1] in ['1', '2', '3']) then
        begin
            
        end;
    until (opp[1] in ['1', '2', '3']);
    write('Ingrese los dias de estadia');
    readln(dEstadia);
    //hacer validacion
    with res do
    begin
        tReservacion:=tReservaciones[StrToInt(opp)];
        tHabitacion:=seleccionarTHab();
        diasEstadia:=dEstadia;
        precioTotal:=tHabitacion.precio * dEstadia;
    end;
    for i:=0 to length(res.clientesEnSesion)-1 do
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
        with res.clientesEnSesion[i] do
        begin
            nombre:=nom;
            apellido:=ape;
            ci:=cedula;
            email:=correo;
            telefono:=tel;
        end;
    end;
    for i:=0 to length(res.ninosEnSesion)-1 do
    begin
        write('Ingrese el nombre del niño ', i+1, ':');
        readln(nom);
        write('Ingrese el apellido del niño ', i+1, ':');
        readln(ape);
        write('Ingrese la edad del niño ', i+1, ':');
        readln(age);
        with res.ninosEnSesion[i] do
        begin
            nombre:=nom;
            apellido:=ape;
            edad:=age;
        end;
    end;
    //mostrar info de la reserva.
    case (opp) of
        '1': begin
            almacenarEnArchivo(archivoIndividual, 'Reservas Individual.txt', res);
        end;
        '2': begin
            almacenarEnArchivo(archivoAcompanado, 'Reservas Acompañado.txt', res);
        end;
        '3': begin
            almacenarEnArchivo(archivoGF, 'Reservas Grupo-Familia.txt', res);
        end;
    end;
end;

function existeReservacion(var archivo: Text; nombreArchivo: string; ID: integer): boolean;
var linea: string;
begin
    if (FileExists(nombreArchivo)) then
    begin
        assign(archivo, nombreArchivo);
        reset(archivo);
        while not eof(archivo) do
        begin
            readLn(archivo, linea);
            if (linea=('ID: ' + IntToStr(ID))) then
            begin
                existeReservacion:=true;
                exit;
            end;
        end;
        existeReservacion:=false;
    end
    else begin
        existeReservacion:=false;
    end;
    close(archivo);
end;

function getReservacion(var archivo: Text; nombreArchivo: string; ID: integer): reservacion;
var
linea: string;
encontrado, esAdulto, esNino: boolean;
nAdultoActual, nNinoActual: integer;
begin
    encontrado:=false;
    esAdulto:=false;
    esNino:=false;
    nAdultoActual:=0;
    nNinoActual:=0;
    assign(archivo, nombreArchivo);
    reset(archivo);
    writeln('.');
    readkey;
    while not eof(archivo) do
    begin
        readLn(archivo, linea);
        if (linea=('ID: ' + IntToStr(ID))) then
        begin
            getReservacion.id:= StrToInt(Copy(linea, 5, length(linea)));
            encontrado:=true;
        end;
        if(encontrado) then
        begin
            if (Copy(linea, 1, 16)=('Tipo de reserva:')) then
            begin
                getReservacion.tReservacion:= Copy(linea, 18, length(linea));
            end;
            if (Copy(linea, 1, 19)=('Tipo de habitacion:')) then
            begin
                case(Copy(linea, 21, length(linea))) of
                    'Sencilla': begin
                        getReservacion.tHabitacion:= tipoHab[1];
                    end;
                    'Doble': begin
                        getReservacion.tHabitacion:= tipoHab[2];
                    end;
                    'Family Room': begin
                        getReservacion.tHabitacion:= tipoHab[3];
                    end;
                    'Suite': begin
                        getReservacion.tHabitacion:= tipoHab[4];
                    end;
                end;
            end;
            if (Copy(linea, 1, 16)=('Dias de estadia:')) then
            begin
                getReservacion.diasEstadia:= StrToInt(Copy(linea, 18, length(linea)));
            end;
            if (Copy(linea, 1, 13)=('Precio total:')) then
            begin
                Delete(linea, 1, 14);
                Delete(linea, length(linea), 1);
                getReservacion.precioTotal:= StrToFloat(linea);
            end;
            if (Copy(linea, 1, 6)=('Adulto'))then
            begin
                Delete(linea, 1, 7);
                Delete(linea, length(linea), 1);
                if(StrToInt(linea)>nAdultoActual) then
                begin
                    nAdultoActual+=1;
                    setLength(getReservacion.clientesEnSesion, nAdultoActual);
                    esAdulto:=true;
                    esNino:=false;
                end;
            end;
            if(esAdulto) then
            begin
                if (Copy(linea, 1, 10)='   Nombre:') then
                begin
                    getReservacion.clientesEnSesion[nAdultoActual-1].nombre:=Copy(linea, 12, length(linea));
                end;
                if (Copy(linea, 1, 12)='   Apellido:') then
                begin
                    getReservacion.clientesEnSesion[nAdultoActual-1].apellido:=Copy(linea, 14, length(linea));
                end;
                if (Copy(linea, 1, 10)='   Cedula:') then
                begin
                    getReservacion.clientesEnSesion[nAdultoActual-1].ci:=Copy(linea, 12, length(linea));
                end;
                if (Copy(linea, 1, 10)='   E-mail:') then
                begin
                    getReservacion.clientesEnSesion[nAdultoActual-1].email:=Copy(linea, 12, length(linea));
                end;
                if (Copy(linea, 1, 12)='   Telefono:') then
                begin
                    getReservacion.clientesEnSesion[nAdultoActual-1].telefono:=Copy(linea, 14, length(linea));
                end;
            end;
            if (UnicodeString(Copy(linea, 1, 5))=('Niño')) then
            begin
                Delete(linea, 1, 6);
                Delete(linea, length(linea), 1);
                if(StrToInt(linea)>nNinoActual) then
                begin
                    nNinoActual+=1;
                    setLength(getReservacion.ninosEnSesion, nNinoActual);
                    esNino:=true;
                    esAdulto:=false;
                end;
            end;
            if(esNino) then
            begin
                if (Copy(linea, 1, 10)='   Nombre:') then
                begin
                    getReservacion.ninosEnSesion[nNinoActual-1].nombre:=Copy(linea, 12, length(linea));
                end;
                if (Copy(linea, 1, 12)='   Apellido:') then
                begin
                    getReservacion.ninosEnSesion[nNinoActual-1].apellido:=Copy(linea, 14, length(linea));
                end;
                if (Copy(linea, 1, 8)='   Edad:') then
                begin
                    getReservacion.ninosEnSesion[nNinoActual-1].apellido:=Copy(linea, 10, length(linea));
                end;
            end;
        end;
    end;
    close(archivo);
end;

{procedure buscarReservacion(var archivo: Text; nombreArchivo: string; ID: integer);
var
linea: String;
mostrar: boolean;
begin
    mostrar:=false;
    if(FileExists(nombreArchivo)) then
    begin
        reset(archivo);
        while not (eof(archivo)) do
        begin
            readLn(archivo, linea);
            if (linea=('ID: ', ID)) then ////ERROR ACA??????
            begin
                mostrar:=true;
                writeln('Datos de la reserva:');
            end;
            if(mostrar) then
            begin
                if(linea='----------------------------------------------------------------------------------') then
                begin
                    exit;
                end;
                writeLn(linea);
            end;
        end;
        writeln('No se consiguio ninguna reserva con esa ID');
    end;
end;}

begin
    //clrscr;
    writeln('Bienvenido al sistema del Hotel Lidotel Boutique Margarita!');
    writeln('Presione cualquier tecla para continuar...');
    readkey;
    repeat
        writeln('Por favor indique la operacion a realizar:');
        writeln('1. Nuevo cliente.');
        writeln('2. Buscar reservacion.');
        writeln('3. Modificar reservacion.');
        writeln('4. Salir.');
        op1:=readkey;
        case(op1) of
            '1': begin
                nuevaReservacion(reservacionActual);
            end;
            '2': begin
                repeat
                    writeln('Por favor, indique el tipo de reserva que desea buscar:');
                    writeln('1. Individual.');
                    writeln('2. Acompañado.');
                    writeln('3. Grupo-Familia.');
                    op2:=readkey;
                    case (op2) of
                        '1': begin
                            archivoSel:= archivoIndividual;
                        end;
                        '2': begin
                            archivoSel:= archivoAcompanado;
                        end;
                        '3': begin
                            archivoSel:= archivoGF;
                        end
                        else begin
                          writeln('Opcion no valida');
                        end;
                    end;
                until (op2[1] in ['1','2','3']);
                tResSel:='Reservas ' + tReservaciones[StrToInt(op2)] + '.txt';
                repeat
                    writeln('Por favor, indique el ID de la reserva que desea buscar:');
                    readln(IDSelInt);
                until (true); //hacer validacion
                writeln(existeReservacion(archivoSel, tResSel, IDSelInt));
                a:=getReservacion(archivoSel, tResSel, IDSelInt);
                writeln(a.id);
                writeln(a.tReservacion);
                writeln(a.tHabitacion.nombre);
                writeln(a.diasEstadia);
                writeln(a.precioTotal);
                writeln(a.clientesEnSesion[0].nombre);
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
    until (op1[1]='4');
end.