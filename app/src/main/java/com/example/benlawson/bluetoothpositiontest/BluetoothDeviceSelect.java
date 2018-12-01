package com.example.benlawson.bluetoothpositiontest;

import android.content.Intent;
import android.os.Build;
import android.support.annotation.RequiresApi;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CheckedTextView;
import android.widget.CompoundButton;
import android.widget.LinearLayout;

import java.util.ArrayList;
import java.util.List;

@RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
public class BluetoothDeviceSelect extends AppCompatActivity {
    private NearbyBTDeviceFinder deviceFinder;
    private Button scanButton, nextButton;
    private LinearLayout devicesList;
    private ArrayList<String> selectedDevices;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bluetooth_device_select);

        deviceFinder = new NearbyBTDeviceFinder(this);
        selectedDevices = new ArrayList<>();

        scanButton = findViewById(R.id.scanForDevicesButton);
        nextButton = findViewById(R.id.selectedDevicesButton);
        devicesList = findViewById(R.id.selectedDevicesList);

        scanButton.setOnClickListener(new Button.OnClickListener() {
            @Override
            public void onClick(View v) {
                onScanButtonClick();
            }
        });

        nextButton.setOnClickListener(new Button.OnClickListener() {
            @Override
            public void onClick(View v) {
                onNextButtonClick();
            }
        });
    }

    public void finishedScanCallback(List<String> deviceNames) {
        for (final String name: deviceNames) {
            final CheckBox newText = new CheckBox(this);
            newText.setText(name);

            newText.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
                @Override
                public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                    if (isChecked) selectedDevices.add(name.trim());
                    else selectedDevices.remove(name.trim());
                }
            });

            devicesList.addView(newText);
        }
    }

    public void onScanButtonClick() {
        deviceFinder.beginScanNearbyDevices();
        devicesList.removeAllViews();
    }

    public void onNextButtonClick() {
        for (String name: selectedDevices) {
            System.out.println(name);
        }

        Intent scanIntent = new Intent(this, BluetoothPositioner.class);
        scanIntent.putExtra("SelectedDevices", selectedDevices);
        startActivity(scanIntent);
    }
}
