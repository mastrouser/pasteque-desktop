//    POS-Tech
//    Based upon Openbravo POS
//
//    Copyright (C) 2007-2009 Openbravo, S.L.
//                       2012 SARL SCOP Scil (http://scil.coop)
//
//    This file is part of POS-Tech.
//
//    POS-Tech is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    POS-Tech is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with POS-Tech.  If not, see <http://www.gnu.org/licenses/>.

package fr.pasteque.pos.widgets;

import java.awt.Component;
import java.awt.Dialog;
import java.awt.Frame;
import java.awt.Window;
import javax.swing.Icon;
import javax.swing.SwingUtilities;

import fr.pasteque.data.loader.ImageLoader;
import fr.pasteque.pos.forms.AppLocal;

/**
 *
 * @author  adrian
 */
public class JNumberDialog extends javax.swing.JDialog {

    public static final int INT_POSITIVE = 0;
    public static final int DOUBLE_POSITIVE = 1;
    
    private Double m_value;
    
    /** Creates new form JNumberDialog */
    public JNumberDialog(java.awt.Frame parent, boolean modal, int type) {
        super(parent, modal);
        init(type);
    }
    
    /** Creates new form JNumberDialog */
    public JNumberDialog(java.awt.Dialog parent, boolean modal, int type) {
        super(parent, modal);
        init(type);
    }
    
    private void init(int type) {
        initComponents(type);
        getRootPane().setDefaultButton(jcmdOK);
        m_jnumber.addEditorKeys(m_jKeys);
        m_jnumber.reset();
        m_jnumber.setDoubleValue(0.0);
        m_jnumber.activate();
        
        m_jPanelTitle.setBorder(RoundedBorder.createGradientBorder());

        m_value = null;
    }
    
    private void setTitle(String title, String message, Icon icon) {
        setTitle(title);
        m_lblMessage.setText(message);
        m_lblMessage.setIcon(icon);
    }
    
    public static Double showEditNumber(Component parent, int type, String title) {
        return showEditNumber(parent, type, title, null, null);
    }
    public static Double showEditNumber(Component parent, int type, String title, String message) {
        return showEditNumber(parent, type, title, message, null);
    }
    public static Double showEditNumber(Component parent, int type, String title, String message, Icon icon) {
        
        Window window = SwingUtilities.windowForComponent(parent);
        
        JNumberDialog myMsg;
        if (window instanceof Frame) { 
            myMsg = new JNumberDialog((Frame) window, true, type);
        } else {
            myMsg = new JNumberDialog((Dialog) window, true, type);
        }
        
        myMsg.setTitle(title, message, icon);
        myMsg.setVisible(true);
        return myMsg.m_value;
    }
    
    private void initComponents(int type) {

        jPanel1 = new javax.swing.JPanel();
        jcmdOK = WidgetsBuilder.createButton(ImageLoader.readImageIcon("button_ok.png"),
                                             AppLocal.getIntString("Button.OK"),
                                             WidgetsBuilder.SIZE_MEDIUM);
        jcmdCancel = WidgetsBuilder.createButton(ImageLoader.readImageIcon("button_cancel.png"),
                                             AppLocal.getIntString("Button.Cancel"),
                                             WidgetsBuilder.SIZE_MEDIUM);;
        jPanel2 = new javax.swing.JPanel();
        jPanelGrid = new javax.swing.JPanel();
        jPanel3 = new javax.swing.JPanel();
        m_jKeys = new JEditorKeys();
        jPanel4 = new javax.swing.JPanel();
        switch (type) {
        case INT_POSITIVE:
            m_jnumber = new JEditorIntegerPositive();
            break;
        case DOUBLE_POSITIVE:
        default:
            m_jnumber = new JEditorDoublePositive();
        }
        m_jPanelTitle = new javax.swing.JPanel();
        m_lblMessage = new javax.swing.JLabel();

        setResizable(false);
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                formWindowClosing(evt);
            }
        });

        jPanel1.setLayout(new java.awt.FlowLayout(java.awt.FlowLayout.RIGHT));

        jcmdOK.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jcmdOKActionPerformed(evt);
            }
        });
        jPanel1.add(jcmdOK);

        jcmdCancel.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jcmdCancelActionPerformed(evt);
            }
        });
        jPanel1.add(jcmdCancel);

        getContentPane().add(jPanel1, java.awt.BorderLayout.SOUTH);

        jPanel2.setBorder(javax.swing.BorderFactory.createEmptyBorder(5, 5, 5, 5));
        jPanel2.setLayout(new java.awt.BorderLayout());

        jPanel3.setLayout(new javax.swing.BoxLayout(jPanel3, javax.swing.BoxLayout.Y_AXIS));
        jPanel3.add(m_jKeys);

        jPanel4.setBorder(javax.swing.BorderFactory.createEmptyBorder(5, 5, 5, 5));
        jPanel4.setLayout(new java.awt.BorderLayout());
        jPanel4.add(m_jnumber, java.awt.BorderLayout.CENTER);

        jPanel3.add(jPanel4);

        jPanelGrid.add(jPanel3);

        jPanel2.add(jPanelGrid, java.awt.BorderLayout.CENTER);

        getContentPane().add(jPanel2, java.awt.BorderLayout.CENTER);

        m_jPanelTitle.setLayout(new java.awt.BorderLayout());

        m_lblMessage.setBorder(javax.swing.BorderFactory.createCompoundBorder(javax.swing.BorderFactory.createMatteBorder(0, 0, 1, 0, java.awt.Color.darkGray), javax.swing.BorderFactory.createEmptyBorder(5, 5, 5, 5)));
        m_jPanelTitle.add(m_lblMessage, java.awt.BorderLayout.CENTER);

        getContentPane().add(m_jPanelTitle, java.awt.BorderLayout.NORTH);

        java.awt.Dimension screenSize = java.awt.Toolkit.getDefaultToolkit().getScreenSize();
        // Icons are to big for a 72dpi density, they don't fit in a popup less than 640x480px
        int minWidth = 230;
        int minHeight = 380;
        int width = WidgetsBuilder.dipToPx(190);
        int height = WidgetsBuilder.dipToPx(340);
        width = Math.max(minWidth, width);
        height = Math.max(minHeight, height);
        // If popup is big enough, make it fullscreen
        if (width > 0.8 * screenSize.width || height > 0.8 * screenSize.height) {
            width = screenSize.width;
            height = screenSize.height;
            this.setUndecorated(true);
        }
        setBounds((screenSize.width-width)/2, (screenSize.height-height)/2, width, height);
    }

    private void jcmdOKActionPerformed(java.awt.event.ActionEvent evt) {


        m_value = m_jnumber.getDoubleValue();
        setVisible(false);
        dispose();

        
    }

    private void jcmdCancelActionPerformed(java.awt.event.ActionEvent evt) {

        setVisible(false);
        dispose();
        
    }

    private void formWindowClosing(java.awt.event.WindowEvent evt) {

        setVisible(false);
        dispose();
        
    }
    
    
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanelGrid;
    private javax.swing.JButton jcmdCancel;
    private javax.swing.JButton jcmdOK;
    private JEditorKeys m_jKeys;
    private javax.swing.JPanel m_jPanelTitle;
    private JEditorNumber m_jnumber;
    private javax.swing.JLabel m_lblMessage;
    
}
