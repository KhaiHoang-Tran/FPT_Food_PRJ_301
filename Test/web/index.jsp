<%-- 
    Document   : index
    Created on : Jan 21, 2026, 9:56:33 AM
    Author     : AN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <form action="MainController" method="post">
            <table border="0">
                <tbody>
                    <tr>
                        <td>
                            <input type="text" name="username" placeholder="enter user name">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="password" name="password" placeholder="enter password">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="submit" name="name">
                        </td>
                    </tr>
                </tbody>
            </table>

        </form>
    </body>
</html>
