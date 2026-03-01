using Prj__Navigations;
using System.Windows;

namespace Prj_Navigations
{
    /// <summary>
    /// Interaction logic for Managers_Login_Window.xaml
    /// </summary>
    public partial class ManagersLoginWindow : Window
    {
        public ManagersLoginWindow()
        {
            InitializeComponent(); 
        }

        private void InitializeComponent()
        {
            throw new NotImplementedException();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            ManagersLoginWindow emp = new ManagersLoginWindow();
            emp.Show();
        }

        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            Employee_Login_Window emp = new Employee_Login_Window();
            emp.Show();
            
        }

        private void Button_Click_2(object sender, RoutedEventArgs e)
        {
            MANAGERS_REGISTRATION_WINDOW reg = new MANAGERS_REGISTRATION_WINDOW();
            reg.Show();
          
        }

        private void Button_Click_3(object sender, RoutedEventArgs e)
        {
            Student_Registration_Window student = new Student_Registration_Window();
            student.Show();
           
        }
    }
}