---
title: Sample_Basic_Demo_RFI
do_process_code_block_titles: True
version: 1.00
source: Sample_Basic_Demo_RFI
Propagation: see api_logic_server_cli/sample_mgr/create_readme.py
---
<style>
  .md-typeset h1,
  .md-content__button {
    display: none;
  }
</style>

!!! pied-piper ":bulb: TL;DR - RFI: Requirements From Interview"

    This illustrates you can supply incomplete requirements, and
    request that AI *interview* you to complete them and create a system.

    Here we create the basic demo for Customer and Orders,
    and request an interview for encouraging sales of *"green"* products.

&nbsp;

## Overview

This app illustrates using IntegrationServices for B2B push-style integrations with APIs, and internal integration with messages.

&nbsp;

![running](images/exec_reqmts/rfi_with_int_bd.png)

Observe the hilit area: data model and logic changes for "green" products.

&nbsp;

## Creation and Setup

We created this system (api, logic, admin app) as follows:

![create_script](images/exec_reqmts/rfi_with_int_bd_rfi.png)
