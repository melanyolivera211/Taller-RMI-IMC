# Taller RMI: Cálculo del IMC con LipeRMI

Sistema distribuido Cliente-Servidor sobre TCP/IP utilizando la tecnología **RMI (Remote Method Invocation)** mediante la biblioteca **LipeRMI** para el cálculo remoto del Índice de Masa Corporal (IMC) y su diagnóstico según los estándares de la OMS.

---

## 📹 Video Explicativo

> 🔗 **Enlace de YouTube:** [Ver video explicativo](https://www.youtube.com/watch?v=TU_LINK_AQUI)  
> *(Reemplazar con el enlace del video)*

---

## 1. Estructura del Proyecto

El sistema está organizado en tres proyectos modulares e independientes:

```text
TallerRMI/
├── ImcRmiLib/                # Biblioteca compartida (DTO e Interfaz Remota)
│   ├── src/
│   │   └── com/ejemplo/imc/lib/
│   │       ├── DatosImc.java
│   │       └── IRemotaCalculoImc.java
│   ├── dist/
│   │   └── ImcRmiLib.jar
│   ├── nbproject/
│   └── build.xml
│
├── ImcRmiServidor/           # Servidor RMI con la lógica de cálculo
│   ├── lib/
│   │   ├── lipermi-1.0.1.jar
│   │   └── ImcRmiLib.jar
│   ├── src/
│   │   └── com/ejemplo/imc/servidor/
│   │       ├── CalculoRmiImcImplem.java
│   │       ├── Servidor.java
│   │       └── Principal.java
│   ├── dist/
│   │   └── ImcRmiServidor.jar
│   ├── nbproject/
│   └── build.xml
│
├── ImcRmiCliente/            # Cliente con interfaz gráfica de usuario (Swing)
│   ├── lib/
│   │   ├── lipermi-1.0.1.jar
│   │   └── ImcRmiLib.jar
│   ├── src/
│   │   └── com/ejemplo/imc/
│   │       ├── cliente/
│   │       │   └── Principal.java
│   │       └── vistas/
│   │           └── VentanaPrincipal.java
│   ├── dist/
│   │   └── ImcRmiCliente.jar
│   ├── nbproject/
│   └── build.xml
│
├── compilar_todo.bat         # Script para compilar los tres proyectos en orden
├── iniciar_servidor.bat      # Script para arrancar el servidor
├── iniciar_cliente.bat       # Script para arrancar la interfaz gráfica del cliente
└── README.md                 # Documentación e instrucciones de uso
```

---

## 2. Descripción de Componentes y Paquetes

### 2.1 `ImcRmiLib` (Paquete: `com.ejemplo.imc.lib`)
* **`DatosImc`:** Clase DTO que implementa `java.io.Serializable`. Transporta peso, altura, resultado e interpretación clínica a través de la red TCP/IP.
* **`IRemotaCalculoImc`:** Interfaz que define el método remoto accesible por los clientes:
  ```java
  public DatosImc calcularImc(DatosImc datos);
  ```
* Se empaqueta como `ImcRmiLib.jar` y se comparte como dependencia hacia el servidor y el cliente.

### 2.2 `ImcRmiServidor` (Paquete: `com.ejemplo.imc.servidor`)
* **`CalculoRmiImcImplem`:** Implementación del servicio remoto. Realiza la fórmula $\text{IMC} = \frac{\text{peso}}{\text{altura}^2}$ y asigna el diagnóstico:
  * $\text{IMC} < 18.5$: *"Debes consultar un Medico, tu peso es muy bajo"*
  * $18.5 \le \text{IMC} \le 24.9$: *"Estas bien de peso"*
  * $24.9 < \text{IMC} \le 29.9$: *"Debes bajar un poco de peso"*
  * $\text{IMC} > 29.9$: *"Debes consultar un Medico, tu peso es muy alto"*
* **`Servidor`:** Inicializa el `CallHandler`, registra el servicio global para `IRemotaCalculoImc.class` y realiza el binding en el puerto `9007`.
* **`Principal`:** Punto de entrada con método `main` para iniciar el servidor.

### 2.3 `ImcRmiCliente` (Paquetes: `com.ejemplo.imc.cliente` y `com.ejemplo.imc.vistas`)
* **`VentanaPrincipal`:** Ventana gráfica (`JFrame`) con pestañas `CONEXION` y `CALCULAR IMC`:
  * En la pestaña **CONEXION**, gestiona la conexión/desconexión hacia el servidor mediante `CallHandler` y `net.sf.lipermi.net.Client`.
  * En la pestaña **CALCULAR IMC**, captura peso y altura, y delega la llamada a `calcularImc(datos)` dentro de un hilo secundario (`Thread`) para evitar el bloqueo de la GUI.
* **`Principal`:** Inicializa y hace visible la ventana `VentanaPrincipal`.

---

## 3. Instrucciones de Compilación y Ejecución

### Opción 1: Mediante Scripts Batch (.bat)

1. **Compilar todos los proyectos:**
   Ejecuta haciendo doble clic en:
   ```cmd
   compilar_todo.bat
   ```
   El script compila primero la biblioteca `ImcRmiLib`, copia su JAR a las carpetas `lib/` de `ImcRmiServidor` y `ImcRmiCliente`, y finalmente compila el servidor y el cliente.

2. **Iniciar el Servidor:**
   Ejecuta:
   ```cmd
   iniciar_servidor.bat
   ```
   Aparecerá una ventana de consola indicando:
   `Servidor iniciado exitosamente en el puerto 9007`

3. **Iniciar el Cliente:**
   Ejecuta:
   ```cmd
   iniciar_cliente.bat
   ```
   Se abrirá la ventana gráfica del cliente **CLIENTE IMC**.

---

### Opción 2: Desde Apache NetBeans

1. Abre **Apache NetBeans**.
2. Selecciona **File -> Open Project...**.
3. Abre los tres proyectos: `ImcRmiLib`, `ImcRmiServidor` e `ImcRmiCliente` (reconocidos automáticamente gracias a sus archivos `nbproject/`).
4. Haz clic derecho sobre **ImcRmiLib** y selecciona **Clean and Build**.
5. Haz clic derecho sobre **ImcRmiServidor** y selecciona **Run**.
6. Haz clic derecho sobre **ImcRmiCliente** y selecciona **Run**.

---

### Opción 3: Por Línea de Comandos

```bash
# Terminal 1: Iniciar Servidor
cd ImcRmiServidor
java -cp "dist/ImcRmiServidor.jar;lib/lipermi-1.0.1.jar;lib/ImcRmiLib.jar" com.ejemplo.imc.servidor.Principal

# Terminal 2: Iniciar Cliente
cd ImcRmiCliente
java -cp "dist/ImcRmiCliente.jar;lib/lipermi-1.0.1.jar;lib/ImcRmiLib.jar" com.ejemplo.imc.cliente.Principal
```

---

## 4. Prueba del Sistema

1. Con el servidor en ejecución, abre el cliente.
2. En la pestaña **CONEXION**, verifica que la IP sea `localhost` y el puerto sea `9007`. Presiona **Conectar**. El estado cambiará a `Conectado` en color verde.
3. Dirígete a la pestaña **CALCULAR IMC**:
   * **Peso:** `78`
   * **Altura:** `1.7`
   * Presiona **CALCULAR**.
4. El servidor procesará la solicitud y retornará:
   * **IMC:** `26.9896...`
   * **Mensaje:** `Debes bajar un poco de peso`
