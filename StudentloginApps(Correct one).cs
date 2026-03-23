using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

using System.Data;
using System.Data.Entity;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Data.SqlTypes;

namespace prj_studentApps
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        

        private void btnlogin_Click(object sender, RoutedEventArgs e)
        {
            SqlConnection con = new SqlConnection(@"Data Source=DESKTOP-FCN9207;Initial Catalog=StudentRecorddemoDB;Integrated Security=True;");

            try
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                String query = "select count(1) from StudentLogin where username=@username AND password=@password";

                SqlCommand sqlcmd = new SqlCommand(query, con);
                sqlcmd.CommandType = CommandType.Text;

                sqlcmd.Parameters.AddWithValue("@username", txtusername.Text);
                sqlcmd.Parameters.AddWithValue("@password", txtpassword.Text);

                int count = Convert.ToInt32(sqlcmd.ExecuteScalar());
                if (count == 1)
                {
                    StudentsRegistration st = new StudentsRegistration();
                    st.Show();

                }
                else
                {
                    MessageBox.Show("Incorrect Username or Password");
                }


            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            finally
            {
                con.Close();
            }


        }
    }
}