@CrearUsuario @Usuario @User
Feature:Crud para crear Usuario

    Background:
        * url 'https://gorest.co.in/public/v2'
        * header Accept = 'application/json'
        * header Content-Type = 'application/json'
        * header Authorization = 'Bearer 700d0c7a86eb84028bf5cd204b11587f812f9d7cd880dc4edbdbd1d407ae9954'
        * def req_headers = {Authorization: 'Bearer 700d0c7a86eb84028bf5cd204b11587f812f9d7cd880dc4edbdbd1d407ae9954'}
        * def dataGenerator = Java.type('Utils.DataGenerator')
        * def payload =
                """
                    {
                        "gender":"male", 
                        "status":"active"
                    }
                """
            * payload.name = dataGenerator.getUserRandom().name
            * payload.email = dataGenerator.getUserRandom().email 
    Scenario: Crear Usuario Nuevo usando FakeData
        * def emailFake = dataGenerator.getEmailRandom()
        * def nameFake = dataGenerator.getRandonName()
        Given path 'users'
        And request {"name":#(nameFake), "gender":"male", "email":#(emailFake), "status":"active"}
        When method Post
        Then status 201
        And match response ==
        """
            {
            "id": "#number",
            "name": "#string",
            "email": "#string",
            "gender": "#string",
            "status": "#string"
            }

        """

    Scenario: Listar los usuarios
        Given path 'users'
        When method get
        Then status 200
    
    Scenario: Obtener Datos de un Usuario
        Given path 'users'
        And request payload
        When method Post
        Then status 201
        * def userid = response.id
        * print userid
        Given path 'users/' , userid
        And headers req_headers
        When method Get
        Then status 200
        And match response.email == payload.email

    Scenario: Actualizar datos de un Usuario
        Given path 'users'
        And request payload
        When method Post
        Then status 201
        * def userid = response.id
        * print userid
        Given path 'users/' , userid
        And headers req_headers
        When method Put
        And request
        """
        {
        "name": "Joselito314"
        }
        """
        Then status 200
    
    Scenario: Actualizar parcialmente un usuario con PATCH
        Given path 'users'
        And request payload
        When method post
        Then status 201
        * def userid = response.id
        * print userid
        Given path 'users/' , userid
        And headers req_headers
        And request
        """
        {
            "name": "Agustin51"
        }
        """
        When method patch
        Then status 200
        
        Given path 'users/' , userid
        And headers req_headers
        When method Get
        Then status 200
        And match response.name == "Agustin51"

    Scenario: Eliminar un usuario
        Given path 'users'
        And request payload
        When method post
        Then status 201
        * def userid = response.id
        * print userid

        Given path 'users/' , userid
        And headers req_headers
        When method Get
        Then status 200

        Given path 'users/' , userid
        And headers req_headers
        When method Delete
        Then status 204

        Given path 'users/' , userid
        And headers req_headers
        When method Get
        Then status 404
        