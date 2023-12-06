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
        documento: string;
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
IDSelInt: integer;
op1, op2: string;
archivoIndividual, archivoAcompanado, archivoGF: Text;
reservacionActual: reservacion;
tResSel, IDSel: string;
resIndSis, resAcoSis, resGFSis, resSel: array of reservacion;
a: reservacion;
function determinarId(var archivo: Text; nombreArchivo: string): integer;
var
linea: string;
idmax: integer;
begin
    idmax:=0;
    if(FileExists(nombreArchivo)) then
    begin
        assign(archivo, nombreArchivo);
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
        close(archivo);
    end;
    determinarId:=idmax+1;
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

procedure actualizarArchivo(var archivo: Text; nombreArchivo: string; reservaciones: array of reservacion);
var i, j: integer;
begin
    assign(archivo, nombreArchivo);
    if(FileExists(nombreArchivo)) then
    begin
        rewrite(archivo);
        for i:=0 to length(reservaciones)-1 do
        begin
            writeLn(archivo, 'Datos de la reserva:');
            writeLn(archivo, 'ID: ', reservaciones[i].id);
            writeLn(archivo, 'Tipo de reserva: ', reservaciones[i].tReservacion);
            writeLn(archivo, 'Tipo de habitacion: ', reservaciones[i].tHabitacion.nombre);
            writeLn(archivo, 'Dias de estadia: ', reservaciones[i].diasEstadia);
            writeLn(archivo, 'Precio total: ', (reservaciones[i].precioTotal):0:2, '$');
            writeLn(archivo, 'Informacion de clientes:');
            for j:=0 to length(reservaciones[i].clientesEnSesion)-1 do
            begin
                writeLn(archivo, 'Adulto ', j+1, ':');
                with reservaciones[i].clientesEnSesion[j] do
                begin
                    writeLn(archivo, '   Nombre: ', nombre);
                    writeLn(archivo, '   Apellido: ', apellido);
                    writeLn(archivo, '   Documento: ', documento);
                    writeLn(archivo, '   E-mail: ', email);
                    writeLn(archivo, '   Telefono: ', telefono);
                end;
            end;
            for j:=0 to length(reservaciones[i].ninosEnSesion)-1 do
            begin
                writeLn(archivo, 'Niño ', j+1, ':');
                with reservaciones[i].ninosEnSesion[j] do
                begin
                    writeLn(archivo, '   Nombre: ', nombre);
                    writeLn(archivo, '   Apellido: ', apellido);
                    writeLn(archivo, '   Edad: ', edad);
                end;
            end;
            writeLn(archivo, '----------------------------------------------------------------------------------');
        end;
    end;
    close(archivo);
end;

procedure nuevaReservacion(var res: reservacion);
var
opp: string;
nAdultos, nNinos, dEstadia, age, i: integer;
nom, ape, tDoc, doc, correo, tel: string;
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
        write('Ingrese el tipo de documento del adulto ' , i+1, ' (V/E/J/G/P): ');
        readln(tDoc);
        write('Ingrese el numero de documento del adulto ', i+1, ':');
        readln(doc);
        write('Ingrese el correo del adulto ', i+1, ':');
        readln(correo);
        write('Ingrese el telefono del adulto ', i+1, ':');
        readln(tel);
        with res.clientesEnSesion[i] do
        begin
            nombre:=nom;
            apellido:=ape;
            documento:=tDoc+doc;
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
    case (opp) of //resIndSis, resAcoSis, resGFSis
        '1': begin
            //almacenarEnArchivo(archivoIndividual, 'Reservas Individual.txt', res);
            setLength(resIndSis, length(resIndSis)+1);
            resIndSis[length(resIndSis)-1]:=res;
            actualizarArchivo(archivoIndividual, 'Reservas Individual.txt', resIndSis);
        end;
        '2': begin
            //almacenarEnArchivo(archivoAcompanado, 'Reservas Acompañado.txt', res);
            setLength(resAcoSis, length(resAcoSis)+1);
            resAcoSis[length(resAcoSis)-1]:=res;
            actualizarArchivo(archivoAcompanado, 'Reservas Acompañado.txt', resAcoSis);
        end;
        '3': begin
            //almacenarEnArchivo(archivoGF, 'Reservas Grupo-Familia.txt', res);
            setLength(resGFSis, length(resGFSis)+1);
            resGFSis[length(resGFSis)-1]:=res;
            actualizarArchivo(archivoGF, 'Reservas Grupo-Familia.txt', resGFSis);
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
                close(archivo);
                exit;
            end;
        end;
        existeReservacion:=false;
        close(archivo);
    end
    else begin
        existeReservacion:=false;
    end;
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
                if (Copy(linea, 1, 13)='   Documento:') then
                begin
                    getReservacion.clientesEnSesion[nAdultoActual-1].documento:=Copy(linea, 15, length(linea));
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
            if(linea='----------------------------------------------------------------------------------') then
            begin
                close(archivo);
                exit;
            end;
        end;
    end;
    close(archivo);
end;

procedure cargarArchivos();
var idmax, i: integer;
begin
    if(FileExists('Reservas Individual.txt')) then
    begin
        idmax:=determinarId(archivoIndividual, 'Reservas Individual.txt')-1;
        for i:=0 to idmax do
        begin
            if(existeReservacion(archivoIndividual, 'Reservas Individual.txt', i)) then
            begin
                setLength(resIndSis, length(resIndSis)+1);
                resIndSis[length(resIndSis)-1]:=getReservacion(archivoIndividual, 'Reservas Individual.txt', i);
            end;
        end;
    end;
    if (FileExists('Reservas Acompañado.txt')) then
    begin
        idmax:=determinarId(archivoAcompanado, 'Reservas Acompañado.txt')-1;
        for i:=0 to idmax do
        begin
            if(existeReservacion(archivoAcompanado, 'Reservas Acompañado.txt', i)) then
            begin
                setLength(resAcoSis, length(resAcoSis)+1);
                resAcoSis[length(resAcoSis)-1]:=getReservacion(archivoAcompanado, 'Reservas Acompañado.txt', i);
            end;
        end;
    end;
    if (FileExists('Reservas Grupo-Familia.txt')) then
    begin
        idmax:=determinarId(archivoGF, 'Reservas Grupo-Familia.txt')-1;
        for i:=0 to idmax do
        begin
            if(existeReservacion(archivoGF, 'Reservas Grupo-Familia.txt', i)) then
            begin
                setLength(resGFSis, length(resGFSis)+1);
                resGFSis[length(resGFSis)-1]:=getReservacion(archivoGF, 'Reservas Grupo-Familia.txt', i);
            end;
        end;
    end;
end;

procedure mostrarDatosReservacion(reservaciones: array of reservacion; pos: integer);
var j: integer;
begin
    writeLn('Datos de la reserva:');
    with reservaciones[pos] do
    begin
        writeLn('ID: ', id);
        writeLn('Tipo de reserva: ', tReservacion);
        writeLn('Tipo de habitacion: ', tHabitacion.nombre);
        writeLn('Dias de estadia: ', diasEstadia);
        writeLn('Precio total: ', (precioTotal):0:2, '$');
    end;
    writeln('Para ver la informacion de los clientes, presione cualquier tecla...');
    readkey;
    clrscr;
    writeLn('Informacion de clientes:');
    for j:=0 to length(reservaciones[pos].clientesEnSesion)-1 do
    begin
        writeLn('Adulto ', j+1, ':');
        with reservaciones[pos].clientesEnSesion[j] do
        begin
            writeLn('   Nombre: ', nombre);
            writeLn('   Apellido: ', apellido);
            writeLn('   Documento: ', documento);
            writeLn('   E-mail: ', email);
            writeLn('   Telefono: ', telefono);
        end;
        if((j<length(reservaciones[pos].clientesEnSesion)-1) or (length(reservaciones[pos].ninosEnSesion)>0)) then
        begin
            writeln('Para ver la informacion de la siguiente persona, presione cualquier tecla...');
            readkey;
            clrscr;
        end;
    end;
    for j:=0 to length(reservaciones[pos].ninosEnSesion)-1 do
    begin
        writeLn('Niño ', j+1, ':');
        with reservaciones[pos].ninosEnSesion[j] do
        begin
            writeLn('   Nombre: ', nombre);
            writeLn('   Apellido: ', apellido);
            writeLn('   Edad: ', edad);
        end;
        if(j<length(reservaciones[pos].ninosEnSesion)-1) then
        begin
            writeln('Para ver la informacion de la siguiente persona, presione cualquier tecla...');
            readkey;
            clrscr;
        end;
    end;
end;

procedure buscarReservacion(reservaciones: array of reservacion; ID: integer);
var
i, posActual: integer;
opp: string;
salir, mostrar: boolean;
begin
    if(length(reservaciones)>0) then
    begin
        for i:=0 to length(reservaciones)-1 do
        begin
            if (reservaciones[i].id=ID) then
            begin
                posActual:=i;
                mostrarDatosReservacion(reservaciones, posActual);
                salir:=false;
                repeat
                    writeln('Indique la reservacion que desea ver ahora:');
                    writeln('0. Salir al menu.     1. Anterior.     2. Siguiente.');
                    opp:=readkey;
                    case (opp) of
                        '0': begin
                            salir:=true;
                            mostrar:=false;
                        end;
                        '1': begin
                            if(posActual=0) then
                            begin
                                writeln('No existe una reservacion anterior.');
                                mostrar:=false;
                            end
                            else begin
                                posActual-=1;
                                mostrar:=true;
                            end;
                        end;
                        '2': begin
                            if(posActual=(length(reservaciones)-1)) then
                            begin
                                writeln('No existe una reservacion siguiente.');
                                mostrar:=false;
                            end
                            else begin
                                posActual+=1;
                                mostrar:=true;
                            end;
                        end
                        else begin
                            writeln('Dato no valido.');
                            mostrar:=false;
                        end;
                    end;
                    if (mostrar) then
                    begin
                        mostrarDatosReservacion(reservaciones, posActual);
                    end;
                until salir;
                exit;
            end;
        end;
        writeln('No se ha conseguido ninguna reserva con esa ID.');
    end
    else begin
        writeln('No se ha conseguido ninguna reserva con esa ID.');
    end;
end;

//MAIN
begin //
    cargarArchivos();
    writeln('.');
    readkey;
    a:=resIndSis[0];
    writeln(a.id);
    writeln(a.tReservacion);
    writeln(a.tHabitacion.nombre);
    writeln(a.diasEstadia);
    writeln(a.precioTotal:0:2);
    writeln(a.clientesEnSesion[0].nombre);
{id: integer;
        tReservacion: string;
        tHabitacion: habitacion;
        diasEstadia: integer;
        clientesEnSesion: array of cliente;
        ninosEnSesion: array of nino;
        precioTotal: real;}


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
                    writeln('Por favor, indique el tipo de reservacion que desea buscar:');
                    writeln('1. Individual.');
                    writeln('2. Acompañado.');
                    writeln('3. Grupo-Familia.');
                    op2:=readkey;
                    case (op2) of
                        '1': begin
                            resSel:= resIndSis;
                        end;
                        '2': begin
                            resSel:= resAcoSis;
                        end;
                        '3': begin
                            resSel:= resGFSis;
                        end
                        else begin
                          writeln('Opcion no valida');
                        end;
                    end;
                until (op2[1] in ['1','2','3']);
                repeat
                    writeln('Por favor, indique el ID de la reserva que desea buscar:');
                    readln(IDSelInt);
                until (true); //hacer validacion
                buscarReservacion(resSel, IDSelInt);
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