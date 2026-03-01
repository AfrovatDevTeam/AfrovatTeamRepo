using Prj_Currency_Converter;
using System.Windows;

namespace Prj_CConverters
{
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void BtnUsersInput_Click(object sender, RoutedEventArgs e)
        {
            UserInputWindow w = new UserInputWindow();
            w.Show();
        }

        private void BtnCurrency_Click(object sender, RoutedEventArgs e)
        {
            Currency_Converter w = new Currency_Converter();
            w.Show();
        }
    }
}

