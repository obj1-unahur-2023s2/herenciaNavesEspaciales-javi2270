class NaveEspacial {
	var velocidad 		
	var direccion 		
	var combustible	
	
	method velocidad() = velocidad
	
	method direccion() = direccion
	
	method combustible() = combustible
	
	method acelerar(cuanto){
		velocidad = 100000.min(velocidad + cuanto)
	}
	method desacelerar(cuanto) {
		velocidad = 0.max(velocidad - cuanto)
	}
	method irHaciaElSol() {
		direccion = 10
	}
	method escaparDelSol() {
		direccion= -10
	}
	method ponerseParaleloAlSol() {
		direccion = 0
	}
	method acercarseUnPocoAlSol() {
		direccion = 10.min(direccion + 1)
	}
	method alejarseUnPocoDelSol() {
		direccion = -10.max(direccion - 1)
	}
		
	method cargarCombustible(cuanto) {
		combustible += cuanto
	}
	
	method descargarCombustible(cuanto) {
		combustible = 0.max(combustible - cuanto)
	}
	
	method prepararViaje() {
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	
	method estaTranquila() {
		return self.combustible() >= 4000 && self.velocidad() <= 12000
	}
	
	// metodos abstractos
	method escapar()
	method avisar()
	method tienePocaActividad()
	//
	
	method recibirAmenaza() {
		self.escapar()
		self.avisar()
	}
	
	method estaDeRelajo() = self.estaTranquila() && self.tienePocaActividad()
}

class NaveBaliza inherits NaveEspacial {
	var colorBaliza 
	var varioColorBaliza = false
	
	method varioColorBaliza() = varioColorBaliza
	
	method colorBaliza() = colorBaliza
	
	method cambiarColorDeBaliza(colorNuevo) {
		colorBaliza = colorNuevo
		varioColorBaliza = true
	}
	
	override method prepararViaje() {
		super()
		self.cambiarColorDeBaliza('verde')
		self.ponerseParaleloAlSol()
	}
	
	override method estaTranquila() {
		return super() && self.colorBaliza() != 'rojo'
		
	}
	
	override method escapar() {
		self.irHaciaElSol()
	}
	
	override method avisar() {
		self.cambiarColorDeBaliza('Rojo')
	}
	
	override method tienePocaActividad() = !self.varioColorBaliza()
}

class NaveDePasajeros inherits NaveEspacial {
	const pasajeros
	var racionesDeComida = 0
	var racionesDeBebida = 0
	
	method pasajeros()= pasajeros
	method racionesDeComida() = racionesDeComida
	method racionesDeBebida() = racionesDeBebida
	
	method cargarComida(unaCantidad) {
		racionesDeComida += unaCantidad
	}
	method cargarBebida(unaCantidad){
		racionesDeBebida += unaCantidad
	}
	
	override method prepararViaje() {
		super()
		self.cargarComida(4*self.pasajeros())
		self.cargarBebida(6*self.pasajeros())
		self.acercarseUnPocoAlSol()	
	}
	
	override method escapar() {
		self.acelerar(2*self.velocidad())
	}
	
	override method avisar() {
		self.cargarComida(self.pasajeros())
		self.cargarBebida(2*self.pasajeros())
	}
	
	override method tienePocaActividad() = self.racionesDeComida() < 50
}
	
class NaveDeCombate inherits NaveEspacial {
	var estaVisible
	var misilesDesplegados
	const mensajes = []

	method ponerseVisible() {
		estaVisible = true
	}
	method ponerseInvisible() {
		estaVisible = false
	}
	
	method estaInvisible () = not estaVisible
	
	method desplegarMisiles() {
		misilesDesplegados = true
	}
	method replegarMisiles() {
		misilesDesplegados = false
	}
	
	method misilesDesplegados()= misilesDesplegados
	
	method emitirMensaje(mensaje) {
		mensajes.add(mensaje)
	}
	
	method mensajesEmitidos() {
		return mensajes.size()
	}
	
	method primerMensajeEmitido(){
		if (mensajes.isEmpty())
			self.error("No hay mensajes")
		return mensajes.first()
	}
	method ultimoMensajeEmitido(){
		if (mensajes.isEmpty())
			self.error("No hay mensajes")
		return mensajes.last()
	}
	method esEscueta() = mensajes.all({m => m.size() < 30})
	
	method emitioMensaje(mensaje) = mensajes.contains(mensaje)
	
	override method prepararViaje() {
		super()
		self.ponerseVisible()
		self.replegarMisiles()	
		self.acelerar(15000)
		self.emitirMensaje('Saliendo  en mision.')
		self.acelerar(15000)
	}
	
	override method estaTranquila() {
		return super() && !self.misilesDesplegados()
	}
	
	override method escapar() {
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	
	override method avisar() {
		self.emitirMensaje('Amenaza recibida.')
	}
	
	override method tienePocaActividad() = self.esEscueta()
}

class NaveHospital inherits NaveDePasajeros {
	var quirofanosPreparados
	
	method quirofanosPreparados() = quirofanosPreparados
	
	method prepararQuirofanos() {
		quirofanosPreparados = true
	}
	
	override method estaTranquila() = super() && !self.quirofanosPreparados()
	
	override method recibirAmenaza() {
		super()
		self.prepararQuirofanos()
	}
	
}

class NaveDeCombateSigilosa inherits NaveDeCombate {
	
	override method estaTranquila() {
		return super() && !self.estaInvisible()
	}
	
	override method recibirAmenaza() {
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()
	}
}








