using System;
using System.Collections.Generic;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

using System.Windows;

namespace Prj_CConverters
{
    public partial class UserInputWindow : Window
    {
        public UserInputWindow()
        {
            InitializeComponent();
        }

        private void BtnAdd_Click(object sender, RoutedEventArgs e)
        {
            string text = txtInput.Text.Trim();

            if (string.IsNullOrEmpty(text))
            {
                MessageBox.Show("Please type something first.");
                return;
            }

            lstItems.Items.Add(text);
            txtInput.Clear();
            txtInput.Focus();
        }

        private void BtnRemove_Click(object sender, RoutedEventArgs e)
        {
            if (lstItems.SelectedItem == null)
            {
                MessageBox.Show("Select an item to remove.");
                return;
            }

            lstItems.Items.Remove(lstItems.SelectedItem);
        }

        private void BtnCount_Click(object sender, RoutedEventArgs e)
        {
            MessageBox.Show("Items in the list: " + lstItems.Items.Count);
        }

        private void BtnClear_Click(object sender, RoutedEventArgs e)
        {
            lstItems.Items.Clear();
        }
    }
}
