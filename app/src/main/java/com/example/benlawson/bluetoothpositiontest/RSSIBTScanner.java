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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;

@RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
public class RSSIBTScanner {
    private boolean isScanning;
    private BluetoothAdapter btAdapter;
    private BluetoothPositioner parentActivity;
    private HashMap<String, LinkedList<Integer>> RSSIValues;
    private ArrayList<String> nameFilters;
    private boolean threadInterruptFlag = false;
    private boolean isDataReadyFlag = false;
    public static final int scanTimes = 20;

    public RSSIBTScanner(BluetoothPositioner parentActivity) {
        this.parentActivity = parentActivity;
        isScanning = false;
        RSSIValues = new HashMap<>();
        checkPermissions();
    }

    public void setNameFilters(List<String> filters) {
        this.nameFilters = (ArrayList<String>) filters;
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
        if (nameFilters == null) return;
        // Clear out list of current devices out of the scan
        RSSIValues.clear();

        // What the handler should do after populating the device names
        Runnable startScanRunnable = new Runnable() {
            @Override
            public void run() {
                while (!threadInterruptFlag && !Thread.currentThread().isInterrupted()) {
                    if (!isScanning) {
                        isScanning = true;
                        btAdapter.startLeScan(leScanCallback);
                    }

                    if (isDataReadyFlag) {
                        parentActivity.finishedScanningRepeatedCallback(RSSIValues);
                    }

                    try {
                        Thread.currentThread().sleep(350);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
                System.out.println("Stopped thread!");
                Thread.currentThread().interrupt();
            }
        };

        Thread scanThread = new Thread(startScanRunnable);
        scanThread.start();

    }

    public void stopScanning() {
        threadInterruptFlag = true;
        btAdapter.stopLeScan(leScanCallback);
        isScanning = false;
    }

    private BluetoothAdapter.LeScanCallback leScanCallback = new BluetoothAdapter.LeScanCallback() {

        @Override
        public void onLeScan(BluetoothDevice device, int rssi, byte[] scanRecord) {
            // If the device is null or it has no name or it is not in our allowed devices, do not add its RSSI values
            if (device == null || device.getName() == null) return;
            String name = device.getName().trim();
            if (name.isEmpty() || !nameFilters.contains(name)) return;

            if (!RSSIValues.containsKey(name)) RSSIValues.put(name, new LinkedList<Integer>());
            if (RSSIValues.get(name).size() == scanTimes) RSSIValues.get(name).removeFirst();
            RSSIValues.get(name).add(rssi);

            // Check if all the LinkedLists have 10 values for the thread interrupt flag
            boolean flag = true;
            for (String devName: RSSIValues.keySet()) {
                if (RSSIValues.get(devName).size() < scanTimes) flag = false;
            }
            isDataReadyFlag = flag;
        }
    };
}
