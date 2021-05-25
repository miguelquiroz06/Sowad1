<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="Css/normalize.css">
    <script src="Js/modernizr-custom.js"></script>
</head>



<body class="cuerpo-login">
    <header>
        <div class="container">
            <div class="navbar">
                <a href="index.jsp"><img src="Img/20170821115345.png" class="logo" alt="Main Logo"></a>
                <ul>
                    <li><a href="index.jsp">Inicio</a></li>
                    <li><a href="#">Productos</a></li>
                    <li><a href="#">Categorias</a></li>
                    <li><a href="#">Sobre Nosotros</a></li>
                    <li><a href="#">Ubicanos</a></li>
                    <li><a href="Login.jsp">Inicia Sesion</a></li>
                </ul>
            </div>
        </div>
    </header>

    <div class="div-body">
        <main class="main-login">
            <div class="Contenedor__todo--login">
                <div class="caja_trasera--login">
                    <div class="Caja__trasera-login">
                        <h3>¿Ya Tienes Una Cuenta?</h3>
                        <p>Inicia Sesion para entrar en la pagina</p>
                        <button id="btn__iniciar-sesion">Iniciar Sesion</button>
                    </div>
                    <div class="caja__trasera-register">
                        <h3>¿Aun no tienes una cuenta?</h3>
                        <p>Registrate para que puedas iniciar sesion</p>
                        <button id="btn__registrarse">Registrarse</button>
                    </div>
                </div>

                <div class="contenedor__login-register">
                    <form action="" class="formulario__login">
                        <h2>Iniciar Sesion</h2>
                        <input type="text" placeholder="Correo Electronico">
                        <input type="password" placeholder="Contraseña">
                        <button>Entrar</button>
                    </form>
                    <form action="" class="formulario__register">
                        <h2>Registrarse</h2>
                        <input type="text" placeholder="Nombre Completo">
                        <input type="text" placeholder="Correo Electronico">
                        <input type="text" placeholder="Usuario">
                        <input type="password" placeholder="Contraseña">
                        <button>Registrarse</button>
                    </form>
                </div>

            </div>
        </main>
    </div>
    <link rel="stylesheet" href="Css/LoginStyle.css">
    <script src="Js/LoginScript.js"></script>
</body>

</html>