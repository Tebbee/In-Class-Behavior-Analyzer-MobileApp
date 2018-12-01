package com.example.benlawson.bluetoothpositiontest;

import android.Manifest;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Handler;
import android.support.annotation.RequiresApi;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.Log;

import java.util.ArrayList;

@RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
public class NearbyBTDeviceFinder {
    private boolean isScanning;
    private BluetoothAdapter btAdapter;
    private BluetoothDeviceSelect parentActivity;
    private ArrayList<String> deviceNames;

    public NearbyBTDeviceFinder(BluetoothDeviceSelect parentActivity) {
        this.parentActivity = parentActivity;
        deviceNames = new ArrayList<>();
        isScanning = false;
        checkPermissions();
    }

    private void checkPermissions() {

        BluetoothManager bluetoothManager = (BluetoothManager) parentActivity.getSystemService(Context.BLUETOOTH_SERVICE);
        btAdapter = bluetoothManager.getAdapter();

        if (!btAdapter.isEnabled()) {
            Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            parentActivity.startActivityForResult(enableBtIntent, 0);
        }

        if (ContextCompat.checkSelfPermission(parentActivity.getBaseContext(), Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(parentActivity, new String[]{Manifest.permission.ACCESS_COARSE_LOCATION}, 0);
        }
    }

    public void beginScanNearbyDevices() {
        // Break away from function if another scan is currently running
        if (isScanning) return;
        // Clear out list of current devices out of the scan
        deviceNames.clear();
        Handler scanHandler = new Handler();

        // What the handler should do after populating the device names
        scanHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                isScanning = false;
                btAdapter.stopLeScan(leScanCallback);
                parentActivity.finishedScanCallback(deviceNames);
            }
        }, 1000);

        // Begin the scan
        btAdapter.startLeScan(leScanCallback);
        isScanning = true;

    }

    private BluetoothAdapter.LeScanCallback leScanCallback = new BluetoothAdapter.LeScanCallback() {

        @Override
        public void onLeScan(BluetoothDevice device, int rssi, byte[] scanRecord) {
            // If the device is null or it has no name, do not add it to the list
            if (device == null || device.getName() == null || device.getName().isEmpty()) return;
            // Only add the device to the list if it does not exist currently in the list
            if (!deviceNames.contains(device.getName())) deviceNames.add(device.getName());
        }
    };
}
