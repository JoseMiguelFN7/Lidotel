program Lidotel;
uses crt;

type
  THabitacion = (Family, Sencilla, Doble, Suite);
  TPersona = record
    Nombre: String;
    Telefono: String;
    Email: String;
  end;
  TReserva = record
    Persona: TPersona;
    CantidadPersonas: Integer;
    TipoHabitacion: THabitacion;
  end;

var op: char;

function ObtenerDatosPersona: TPersona;
begin
  writeln('Ingrese su nombre:');
  readln(reserva.Nombre);
  
  writeln('Ingrese su telefono:');
  readln(reserva.Telefono);
  
  writeln('Ingrese su email:');
  readln(reserva.Email);
end;

procedure PedirDatosReserva(var reserva: TReserva);
begin
  writeln('¿Está solo o con otras personas? (solo/otras)');
  writeln('1. Solo.');
  writeln('2. Otras.');
  op:= readkey;
  case op of
	'1':begin
		reserva.CantidadPersonas := 1;
		reserva.Persona := ObtenerDatosPersona;
	end;
	'2':begin
		writeln('Ingrese la cantidad de personas:');
		readln(reserva.CantidadPersonas);
		reserva.Persona := ObtenerDatosPersona;
		 writeln('¿Es una reserva familiar o de grupo? (familiar/grupo)');
		writeln('1. Familiar.');
		writeln('2. Grupo.');
		op2:= readkey;
		case op of
			'1':begin
				writeln('Ingrese el tipo de habitacion (Family, Sencilla, Doble, Suite):');
				readln(reserva.TipoHabitacion);
			end
			'2':begin
				writeln('Ingrese el tipo de habitacion (Sencilla, Doble, Suite):');
				readln(reserva.TipoHabitacion);
			end
			else
				writeln('Seleccione una opcion valida.');
			end;
	else
		writeln('Seleccione una opcion valida.');
	end;
  end;	
end;

procedure MostrarReserva(reserva: TReserva);
begin
  writeln('Reserva realizada:');
  writeln('Nombre: ', reserva.Persona.Nombre);
  writeln('Telefono: ', reserva.Persona.Telefono);
  writeln('Email: ', reserva.Persona.Email);
  writeln('Cantidad de personas: ', reserva.CantidadPersonas);
  writeln('Tipo de habitacion: ', reserva.TipoHabitacion);
end;

begin
    
end.
