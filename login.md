&nbsp;login





1 correct details





string username = "Sally";                                                                                                                              

&nbsp;string password = "face";



&nbsp;try

&nbsp;{

&nbsp;    if (username == "Sally" \&\& password == "face")

&nbsp;    {

&nbsp;        Console.WriteLine("Login Sucessful");

&nbsp;    }

&nbsp;    else

&nbsp;    {

&nbsp;        Console.WriteLine("Incorrect Password or Username");

&nbsp;    }

&nbsp;}

&nbsp;catch (Exception ex)

&nbsp;{

&nbsp;    Console.WriteLine(ex.ToString());

&nbsp;}



result

Login Successful



`2 incorrect details



&nbsp;string username = "Ally";

&nbsp;string password = "face";



&nbsp;try

&nbsp;{

&nbsp;    if (username == "Sally" \&\& password == "face")

&nbsp;    {

&nbsp;        Console.WriteLine("Login Sucessful");

&nbsp;    }

&nbsp;    else

&nbsp;    {

&nbsp;        Console.WriteLine("Incorrect Password or Username");

&nbsp;    }

&nbsp;}

&nbsp;catch (Exception ex)

&nbsp;{

&nbsp;    Console.WriteLine(ex.ToString());

&nbsp;}





Result

incorrect Username or Password

