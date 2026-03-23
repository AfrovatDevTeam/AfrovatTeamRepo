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

namespace Window_creation
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();

            string[] a = { "Rand", "Dollar", "Ruppes" };
            string[] b = { "Dollar", "Rupees", "Rand" };

            combobox1.ItemsSource = a;
            combobox2.ItemsSource = b;
        }

        private void btnlogin_Click(object sender, RoutedEventArgs e)
        {
            int i = int.Parse(txtenteramount.Text);

            if (combobox1.SelectedItem.ToString() == "Rand" && combobox2.SelectedItem.ToString() == "Dollar")
            {
                int resilt = i * 16;
                txtresult.Text = resilt.ToString() + " Converted Result";
            }
            else if (combobox1.SelectedItem.ToString() == "Rupees" && combobox2.SelectedItem.ToString() == "Dollar")
            {
                int resilt = i * 25;
                txtresult.Text = resilt.ToString() + " Converted Result";
            }
            else if (combobox1.SelectedItem.ToString() == "Rand" && combobox2.SelectedItem.ToString() == "Rupees")
            {
                int resilt = i * 6;
                txtresult.Text = resilt.ToString() + " Converted Result";
            }
        }
    }
}