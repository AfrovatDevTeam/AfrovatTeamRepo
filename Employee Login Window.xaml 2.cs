using Prj__Navigations;
using System.Windows;

namespace Prj_Navigations
{
    public partial class Employee_Login_Window : Window
    {
        public Employee_Login_Window()
        {
            InitializeComponent();
        }

        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            ManagersLoginWindow man = new ManagersLoginWindow();
            man.Show();
            this.Close();
        }

        private void Button_Click_2(object sender, RoutedEventArgs e)
        {
            ManagersLoginWindow man = new ManagersLoginWindow();
            man.Show();
        }

        private void Button_Click_3(object sender, RoutedEventArgs e)
        {
            Student_Registration_Window student = new Student_Registration_Window();
            student.Show();
        }

        private void Button_Click_4(object sender, RoutedEventArgs e)
        {
            MainWindow main = new MainWindow();
            this.Close();
        }
    }
}
